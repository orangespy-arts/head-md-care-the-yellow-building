using UnityEngine;
using UnityEngine.InputSystem;
using System.Collections;
using System.Collections.Generic;

// 四状态体验循环（阶段1：骨架。State3/State4 为占位，内容在阶段3/4实装）
//   Screensaver  相机跟猫，等观众点击（开机默认）
//   Interactive  九宫格固定机位，房间可交互
//   Dissolving   房间内容依次消失（占位）
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

    [Header("阶段1占位时长（State3/4 实装后删除）")]
    public float placeholderDissolveSeconds = 2f;
    public float placeholderEndingSeconds = 2f;

    public GameState State { get; private set; } = GameState.Screensaver;

    private float idleTimer = 0f;
    private int enterFrame = -1;
    private Vector2 lastMousePos;

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

    void Start()
    {
        lastMousePos = Mouse.current != null ? Mouse.current.position.ReadValue() : Vector2.zero;
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
        StartCoroutine(PlaceholderCycle(delay));
    }

    private IEnumerator PlaceholderCycle(float delay)
    {
        if (delay > 0f) yield return new WaitForSeconds(delay);

        // TODO 阶段3：逐房间 RoomContents.Disappear() + 猫 Hide()
        yield return new WaitForSeconds(placeholderDissolveSeconds);

        State = GameState.Ending;
        Debug.Log("[GameManager] → Ending");

        // TODO 阶段4：相机去 endingView、猫 AppearAt、变黑、黑屏重置
        yield return new WaitForSeconds(placeholderEndingSeconds);

        ResetAll();
    }

    private void ResetAll()
    {
        completedRooms.Clear();
        idleTimer = 0f;
        ResetAllRooms();
        // TODO 阶段3/4：RoomContents.ResetContents()、猫 ResetCat()、灯光复原
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
