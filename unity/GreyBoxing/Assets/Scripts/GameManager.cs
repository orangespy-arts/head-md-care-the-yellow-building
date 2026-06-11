using UnityEngine;
using UnityEngine.InputSystem;

public enum GameMode { Default, Screensaver }

public interface IRoomResettable
{
    void ResetRoom();
}

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    [Header("Screensaver 触发")]
    public float idleThreshold = 60f;
    public bool mouseMoveCountsAsActivity = true;

    public GameMode CurrentMode { get; private set; } = GameMode.Default;

    private float idleTimer = 0f;
    private int exitFrame = -1;
    private Vector2 lastMousePos;

    public static bool InteractionEnabled =>
        Instance != null
        && Instance.CurrentMode == GameMode.Default
        && Time.frameCount != Instance.exitFrame;

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
        if (CurrentMode == GameMode.Default)
        {
            // 任何指针按下（鼠标/触控板 tap/触摸/笔）都算活动，重置 idle
            bool active = Pointer.current != null && Pointer.current.press.wasPressedThisFrame;
            if (Mouse.current != null)
            {
                Vector2 currentMousePos = Mouse.current.position.ReadValue();
                if (mouseMoveCountsAsActivity && (currentMousePos - lastMousePos).sqrMagnitude > 1f)
                    active = true;
                lastMousePos = currentMousePos;
            }

            if (active) idleTimer = 0f;
            else idleTimer += Time.deltaTime;

            if (idleTimer >= idleThreshold)
                EnterScreensaver();
        }
        else
        {
            if (Pointer.current != null && Pointer.current.press.wasPressedThisFrame)
                ExitScreensaver();
        }
    }

    private void EnterScreensaver()
    {
        CurrentMode = GameMode.Screensaver;
        idleTimer = 0f;
    }

    private void ExitScreensaver()
    {
        CurrentMode = GameMode.Default;
        idleTimer = 0f;
        exitFrame = Time.frameCount;
        ResetAllRooms();
    }

    private void ResetAllRooms()
    {
        var all = FindObjectsOfType<MonoBehaviour>(true);
        foreach (var mb in all)
            if (mb is IRoomResettable r) r.ResetRoom();
    }
}
