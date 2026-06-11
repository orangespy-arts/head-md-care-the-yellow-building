# The Yellow Building — Claude Code 工作文档
## 更新于 June 10, 2026

---

## 项目背景

Unity 交互装置，6月16日终展。从对面楼窗口望出去看一栋黄色建筑里九个房间的居民生活。3渲2（URP Toon Shader）。

**团队分工：**
- Orangespy：scripting / animation / rigging
- Lisa：assets / scene / 音频导入
- zhanlan：文字资产

**仓库根目录有四个记忆文档：** CLAUDE.md / ARCHITECTURE.md / DECISIONS.md / CHANGELOG.md

---

## 场景结构

九个房间排列在 3x3 网格：

```
A1(ToiletMan)  A2(WorkMan)  A3(Cat起始)
B1(Boy)        B2(OldWoman) B3
C1             C2(舞者)     C3(Couple)
```

坐标系：行号 = 高度层级，列号 = 左右位置。

---

## 脚本清单

| 文件名 | 类名 | 挂载位置 | 用途 |
|---|---|---|---|
| GameManager.cs | GameManager | 空 GameObject | 模式管理 |
| CameraController.cs | CameraController | Main Camera | 相机控制 |
| CatController.cs | CatController | CatModel | 猫跳跃逻辑 |
| BoyAnimControl.cs | KidBehaviour | B1 人物 | Boy 交互 |
| OldWoman.cs | OldWomanTalk | B2 人物 | OldWoman 交互 |
| TalkComplain.cs | CoupleRoom | C3 Couple parent | Couple 交互 |
| ToiletMan.cs | ToiletMan | A1 人物 | ToiletMan 交互 |
| WorkManControl.cs | BotherWorker | A2 人物 | WorkMan 交互 |

**注意：文件名和类名在多个脚本中不一致，以上表格为准。**

---

## 两种模式架构

### Default 模式
- 猫在窗台间自动跳跃
- 所有房间交互正常响应点击
- 相机在默认位置

### Screensaver 模式
- 无操作超过 idleThreshold 秒自动触发
- 猫继续跳跃（逻辑不变）
- 相机推进（screensaverOffset）并跟随猫的 Y/Z 位置
- 所有房间交互被屏蔽（GameManager.InteractionEnabled 返回 false）
- 点击屏幕退出回 Default 模式并 Reset 所有房间

---

## 当前代码

### GameManager.cs

```csharp
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
        lastMousePos = Mouse.current.position.ReadValue();
    }

    void Update()
    {
        if (CurrentMode == GameMode.Default)
        {
            bool active = clickAction.WasPressedThisFrame();
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
            // Pointer.current 自动覆盖 鼠标/触控板/触摸/笔，比 Mouse.leftButton 更稳
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
```

（`Awake` 里创建并 Enable 一个 `clickAction = new InputAction(..., "<Mouse>/leftButton")`，`OnDestroy` 里 Disable。）

### CameraController.cs

```csharp
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [Header("Screensaver 相机推进")]
    public Vector3 screensaverOffset = new Vector3(-6.46f, 0, 0);
    public float enterTransitionSpeed = 2f;  // 当前未使用，进出都用 followSpeed

    [Header("猫跟随")]
    public Transform catTarget;
    public float followSpeed = 3f;

    private Vector3 defaultPosition;

    void Start()
    {
        defaultPosition = transform.position;
    }

    void Update()
    {
        if (GameManager.Instance == null) return;
        GameMode mode = GameManager.Instance.CurrentMode;

        Vector3 targetPos;
        if (mode == GameMode.Screensaver)
        {
            targetPos = defaultPosition + screensaverOffset;

            // Y 和 Z 跟猫，X 只推进不跟猫
            if (catTarget != null)
            {
                targetPos.y = catTarget.position.y;
                targetPos.z = catTarget.position.z;
            }
        }
        else
        {
            // 退出 screensaver：朝默认位置做同样的 Lerp，平滑 zoom out 回去
            targetPos = defaultPosition;
        }

        transform.position = Vector3.Lerp(transform.position, targetPos, Time.deltaTime * followSpeed);
    }
}
```

### CatController.cs

```csharp
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CatController : MonoBehaviour
{
    [Header("窗台")]
    public Transform[] balconies;

    [Header("朝向参考点")]
    public Transform facingTarget;

    [Header("参数")]
    public float minStayTime = 2f;
    public float maxStayTime = 5f;
    public float jumpClipLength = 1.3f;
    public float arcHeight = 3f;
    public Vector3 positionOffset = Vector3.zero;

    private Animator animator;
    private int currentIndex = 2; // 起始 A3

    private int[,] coords = new int[,]
    {
        {0, 0}, // A1
        {0, 1}, // A2
        {0, 2}, // A3
        {1, 0}, // B1
        {1, 1}, // B2
        {1, 2}, // B3
        {2, 0}, // C1
        {2, 1}, // C2
        {2, 2}, // C3
    };

    void Start()
    {
        animator = GetComponentInChildren<Animator>();
        currentIndex = 2;
        transform.position = balconies[currentIndex].position + positionOffset;
        FaceTarget();
        StartCoroutine(JumpLoop());
    }

    private void FaceTarget()
    {
        if (facingTarget == null) return;
        Vector3 dir = facingTarget.position - transform.position;
        dir.y = 0;
        if (dir.sqrMagnitude > 0.001f)
            transform.rotation = Quaternion.LookRotation(dir);
    }

    private bool IsValidJump(int from, int to)
    {
        int colDiff = Mathf.Abs(coords[from, 0] - coords[to, 0]);
        int rowDiff = Mathf.Abs(coords[from, 1] - coords[to, 1]);
        return colDiff > 0 && rowDiff <= 1;
    }

    private IEnumerator JumpLoop()
    {
        while (true)
        {
            float stayTime = Random.Range(minStayTime, maxStayTime);
            yield return new WaitForSeconds(stayTime);

            List<int> validTargets = new List<int>();
            for (int i = 0; i < balconies.Length; i++)
            {
                if (i != currentIndex && IsValidJump(currentIndex, i))
                    validTargets.Add(i);
            }

            if (validTargets.Count == 0) continue;

            int nextIndex = validTargets[Random.Range(0, validTargets.Count)];

            Vector3 jumpDir = balconies[nextIndex].position - transform.position;
            jumpDir.y = 0;
            if (jumpDir.sqrMagnitude > 0.001f)
                transform.rotation = Quaternion.LookRotation(jumpDir);

            animator.SetTrigger("DoJump");

            Vector3 startPos = transform.position;
            Vector3 endPos = balconies[nextIndex].position + positionOffset;
            float elapsed = 0f;

            while (elapsed < jumpClipLength)
            {
                elapsed += Time.deltaTime;
                float t = Mathf.Clamp01(elapsed / jumpClipLength);
                Vector3 flatPos = Vector3.Lerp(startPos, endPos, t);
                flatPos.y += arcHeight * Mathf.Sin(t * Mathf.PI);
                transform.position = flatPos;
                yield return null;
            }

            currentIndex = nextIndex;
            transform.position = endPos;
            FaceTarget();
        }
    }
}
```

---

## 今日已完成的工作（June 10）

### 猫系统
- 修复 Humanoid rig / Generic clip 冲突（两个 fbx 都改成 Humanoid）
- 修复朝向 bug：用 facingTarget 空物体控制朝向
- 实现抛物线跳跃位移（arcHeight 可调）
- 加入 Land_stop-edit 落地动画（Bake Into Pose Y 用 Feet）
- Animator：Pet_sit 默认，DoJump Trigger 触发 JumpCurve，Has Exit Time 关闭，JumpCurve 播完自动回 Pet_sit

### Core 系统
- GameManager.cs 写完（两模式、IRoomResettable 接口、新版 Input System）
- CameraController.cs 写完（推进 + 猫跟随）
- 五个房间脚本批量改完（加接口、加屏蔽、加 ResetRoom）
- **修复 screensaver 退出失效**（详见下）
- **退出 screensaver 改为平滑 zoom out**（详见下）

---

## 已修复：Screensaver 退出失效（June 10）

**现象：** Screensaver 模式运行正常，点击屏幕不退出回 Default。

**排查过程（逐层定位，结论很反直觉）：**

1. 先在 screensaver 分支加 log → 确认 `Update` 每帧在跑、`Mouse.current=OK`。排除「Update 没跑 / GameObject 没 active / 没第二个实例」。
2. 同时读 `clickAction.WasPressedThisFrame()` 和 `Mouse.current.leftButton.wasPressedThisFrame` → 点击时**两个都是 false**。
3. 改读按住状态 `Mouse.current.leftButton.isPressed` → 物理按住也**读不到**。说明左键的按下根本没进 Mouse 通道。
4. 扩展到所有指针来源（`Mouse` / `Pointer` / `Touchscreen` / `Keyboard`）一起判断 → 点击生效了。

**根因：** 这是**笔记本**，触控板的 tap-to-click 在新版 Input System 里不一定走 `Mouse.leftButton`，可能走 `Touchscreen`/`Pen` 通道，所以 `Mouse.current.leftButton` 永远 false。

**最终方案：** 退出判断用 `Pointer.current.press.wasPressedThisFrame`。`Pointer.current` 是 Mouse/Pen/Touchscreen 的公共基类，自动指向最近使用的指针设备，一行覆盖所有点击类输入：

```csharp
else
{
    if (Pointer.current != null && Pointer.current.press.wasPressedThisFrame)
        ExitScreensaver();
}
```

> 注意：Default 分支判断「活动」仍用 `clickAction`（绑 Mouse.leftButton），但 `mouseMoveCountsAsActivity` 靠鼠标移动重置 idle，实际不影响触发，暂未改。

## 已完成：退出 screensaver 平滑 zoom out（June 10）

**问题：** 进入 screensaver 是 Lerp 平滑推进，但退出时 `transform.position = defaultPosition` 一帧瞬移，视觉上卡一下。

**方案：** CameraController 改成进出对称——两种模式都朝 `targetPos` 做 `Vector3.Lerp(..., Time.deltaTime * followSpeed)`，退出时 `targetPos = defaultPosition`，于是平滑 zoom out。删掉了不再需要的 `lastMode` 字段。退出速度 = 进入速度（都用 `followSpeed`，默认 3）；要进出不同速可把 `enterTransitionSpeed` 接上单独控制退出。

---

## 剩余工作（优先级顺序）

1. ~~修复 screensaver 退出 bug~~ ✅ 已修复（Pointer.current）
2. ~~退出 screensaver 平滑 zoom out~~ ✅ 已完成
3. 文字资产：AngerWords x3、Complain x3、TalkOnPhone 字幕
4. Final 工程整合：迁移后点击失效问题
5. Toon Shader 配置：舞者消失改淡出

**小遗留（不急）：** GameManager Default 分支的「活动检测」仍只认 `clickAction`（Mouse.leftButton），笔记本触控板 tap 不算活动；但鼠标移动会重置 idle，实际不影响 screensaver 触发。若以后要触控板 tap 也算活动，同样换成 `Pointer.current.press`。