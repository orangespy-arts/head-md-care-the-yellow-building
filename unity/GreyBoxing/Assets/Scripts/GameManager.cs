using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;
using System.Collections.Generic;

// 四状态体验循环（阶段3：Dissolving 已实装，Ending 仍为占位）
//   Screensaver  相机跟猫，等观众点击（开机默认）
//   Interactive  九宫格固定机位，房间可交互
//   Dissolving   房间内容依次消失 → 猫消失
//   Ending       zoom out 结尾（占位）→ 重置回 Screensaver
public enum GameState { Screensaver, Interactive, Dissolving, Ending }

public interface IRoomResettable
{
    void ResetRoom();
}

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    [Header("State2 → State3 触发（满足其一）")]
    [Tooltip("Interactive 无操作超过这个秒数")]
    public float idleDissolveThreshold = 45f;
    [Tooltip("全部房间交互完成后，停这么久再开始")]
    public float allCompleteDelay = 3f;
    public bool mouseMoveCountsAsActivity = true;

    [Header("九个房间（拖 empty 父物体，下面放模型；消失顺序 = 数组顺序）")]
    public GameObject[] rooms = new GameObject[9];

    [Header("State3 消失节奏")]
    [Tooltip("房间与房间之间的间隔（秒）")]
    public float roomDissolveInterval = 0.8f;
    [Tooltip("房间内子物体逐个消失的间隔（秒）")]
    public float objectInterval = 0.25f;
    [Tooltip("最后一个房间清空后，到猫消失的停顿")]
    public float catDisappearDelay = 1f;
    [Tooltip("猫消失后，到进入 State4 的停顿")]
    public float afterDissolveHold = 1.5f;

    [Header("引用")]
    public CatController cat;

    [Header("State4 结尾")]
    public Transform endingCatPerch;
    public Light sunLight;
    public float fadeToBlackDuration = 3f;
    public float holdBlackDuration   = 2f;
    public float endingCameraHold    = 3f;

    [Header("测试开关（上展前必须关掉）")]
    [Tooltip("勾上：跳过屏保，Play 直接进 Interactive")]
    public bool debugSkipScreensaver = false;

    public GameState State { get; private set; } = GameState.Screensaver;

    private float idleTimer = 0f;
    private int enterFrame = -1;
    private Vector2 lastMousePos;
    private float initialSunIntensity;

    // 房间注册/完成（阶段2接入）
    private readonly HashSet<string> registeredRooms = new HashSet<string>();
    private readonly HashSet<string> completedRooms = new HashSet<string>();

    // 从 Screensaver 点进来的那一下不传给房间
    public static bool InteractionEnabled =>
        Instance != null
        && Instance.State == GameState.Interactive
        && Time.frameCount != Instance.enterFrame;

    void Awake()
    {
        if (Instance != null && Instance != this) { Destroy(gameObject); return; }
        Instance = this;
    }

    // 记录每个子物体的初始 active 状态，循环重置时按原样复原
    // （比如某些道具本来就是关着的，不能复原成全开）
    private readonly Dictionary<GameObject, bool> initialActive = new Dictionary<GameObject, bool>();

    void Start()
    {
        lastMousePos = Mouse.current != null ? Mouse.current.position.ReadValue() : Vector2.zero;

        foreach (var room in rooms)
        {
            if (room == null) continue;
            foreach (Transform child in room.transform)
                initialActive[child.gameObject] = child.gameObject.activeSelf;
        }

        if (sunLight != null) initialSunIntensity = sunLight.intensity;

        if (debugSkipScreensaver) EnterInteractive();
    }

    void Update()
    {
        // 任何指针按下（鼠标/触控板 tap/触摸/笔）
        bool pressed = Pointer.current != null && Pointer.current.press.wasPressedThisFrame;

        switch (State)
        {
            case GameState.Screensaver:
                if (pressed) EnterInteractive();
                break;

            case GameState.Interactive:
                bool active = pressed;
                if (Mouse.current != null)
                {
                    Vector2 currentMousePos = Mouse.current.position.ReadValue();
                    if (mouseMoveCountsAsActivity && (currentMousePos - lastMousePos).sqrMagnitude > 1f)
                        active = true;
                    lastMousePos = currentMousePos;
                }

                if (active) idleTimer = 0f;
                else idleTimer += Time.deltaTime;

                if (idleTimer >= idleDissolveThreshold)
                    BeginDissolve(0f, "闲置超时");
                break;

            // Dissolving / Ending 由协程自动推进，忽略输入
        }
    }

    private void EnterInteractive()
    {
        State = GameState.Interactive;
        idleTimer = 0f;
        enterFrame = Time.frameCount;
        ResetAllRooms(); // 等同旧版退出 screensaver 时的重置
        Debug.Log("[GameManager] → Interactive");
    }

    // ---- 房间注册 / 完成上报（阶段2：各房间 Start 注册、完成时上报）----

    public static void RegisterInteractive(string roomId)
    {
        if (Instance != null) Instance.registeredRooms.Add(roomId);
    }

    public static void ReportCompletion(string roomId)
    {
        if (Instance == null || Instance.State != GameState.Interactive) return;
        if (!Instance.completedRooms.Add(roomId)) return; // 重复上报忽略（如 ToiletMan 反复点击）
        Debug.Log($"[GameManager] 房间完成 {roomId}（{Instance.completedRooms.Count}/{Instance.registeredRooms.Count}）");

        if (Instance.registeredRooms.Count > 0 &&
            Instance.completedRooms.Count >= Instance.registeredRooms.Count)
            Instance.BeginDissolve(Instance.allCompleteDelay, "全部房间完成");
    }

    // ---- State3 / State4（阶段1：占位循环，把四个状态真实跑通）----

    private void BeginDissolve(float delay, string reason)
    {
        if (State != GameState.Interactive) return; // 防双触发
        State = GameState.Dissolving;
        Debug.Log($"[GameManager] → Dissolving（{reason}）");
        StartCoroutine(DissolveSequence(delay));
    }

    private IEnumerator DissolveSequence(float delay)
    {
        if (delay > 0f) yield return new WaitForSeconds(delay);

        // 逐房间消失（顺序 = Inspector 里 rooms 数组顺序，空槽位跳过）
        // 每个房间自己开协程，房间之间可以重叠消失
        foreach (var room in rooms)
        {
            if (room == null) continue;
            StartCoroutine(DissolveRoom(room));
            yield return new WaitForSeconds(roomDissolveInterval);
        }

        yield return new WaitForSeconds(catDisappearDelay);
        if (cat != null) cat.Hide();
        yield return new WaitForSeconds(afterDissolveHold);

        State = GameState.Ending;
        Debug.Log("[GameManager] → Ending");

        if (cat != null && endingCatPerch != null) cat.AppearAt(endingCatPerch);
        yield return new WaitForSeconds(endingCameraHold);

        yield return StartCoroutine(FadeToBlack());
        yield return new WaitForSeconds(holdBlackDuration);

        ResetAll();
    }

    private IEnumerator FadeToBlack()
    {
        if (sunLight == null) yield break;

        float elapsed        = 0f;
        float startIntensity = sunLight.intensity;
        while (elapsed < fadeToBlackDuration)
        {
            elapsed += Time.deltaTime;
            float t  = Mathf.Clamp01(elapsed / fadeToBlackDuration);
            sunLight.intensity = Mathf.Lerp(startIntensity, 0f, t);
            yield return null;
        }
        sunLight.intensity = 0f;
    }

    // 房间内子物体按层级顺序逐个消失（只动直接子物体；要整组一起消失就把它们包在一个子 empty 里）
    private IEnumerator DissolveRoom(GameObject room)
    {
        if (room.transform.childCount == 0)
        {
            Debug.LogWarning($"[GameManager] {room.name} 没有任何子物体！要消失的模型必须放在它下面一层。" +
                "另外确认拖进 Rooms 的是 Hierarchy 里的场景物体，不是 Project 里的 prefab。");
            yield break;
        }

        int hidden = 0;
        foreach (Transform child in room.transform)
        {
            if (child.gameObject.activeSelf)
            {
                child.gameObject.SetActive(false);
                hidden++;
                yield return new WaitForSeconds(objectInterval);
            }
        }
        Debug.Log($"[GameManager] {room.name} 已清空（隐藏了 {hidden} 个子物体）");
    }

    private void ResetAll()
    {
        StopAllCoroutines(); // 终止可能还在跑的 DissolveRoom

        completedRooms.Clear();
        idleTimer = 0f;

        // 子物体按初始 active 状态复原
        foreach (var room in rooms)
        {
            if (room == null) continue;
            foreach (Transform child in room.transform)
            {
                bool wasActive;
                child.gameObject.SetActive(
                    initialActive.TryGetValue(child.gameObject, out wasActive) ? wasActive : true);
            }
        }

        ResetAllRooms();
        if (cat != null) cat.ResetCat();
        if (sunLight != null) sunLight.intensity = initialSunIntensity;

        State = GameState.Screensaver;
        Debug.Log("[GameManager] → Screensaver（循环重置）");
    }

    private void ResetAllRooms()
    {
        var all = FindObjectsOfType<MonoBehaviour>(true);
        foreach (var mb in all)
            if (mb is IRoomResettable r) r.ResetRoom();
    }
}
