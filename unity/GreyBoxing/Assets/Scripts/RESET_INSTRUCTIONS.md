# 房间脚本 Reset 批量修改指南

## 背景

项目有 screensaver 模式。退出 screensaver 时 GameManager 会调用所有实现了 `IRoomResettable` 接口的脚本的 `ResetRoom()` 方法，把房间恢复到初始状态。`IRoomResettable` 接口已在 GameManager.cs 中定义，无需新建。

同时，screensaver 期间所有点击交互需要被屏蔽，通过 `GameManager.InteractionEnabled` 判断。

## 需要修改的脚本（注意文件名和类名不一致）

| 文件名 | 类名 | 房间 |
|---|---|---|
| BoyAnimControl.cs | KidBehaviour | B1 |
| OldWoman.cs | OldWomanTalk | B2 |
| TalkComplain.cs | CoupleRoom | C2/C3 |
| ToiletMan.cs | ToiletMan | A1 |
| WorkManControl.cs | BotherWorker | A2 |

Cat.cs、CameraControl.cs、GameManager.cs 不要动。

## 每个脚本统一的两处修改

### 修改1：类声明追加 IRoomResettable 接口

```csharp
// 例
public class KidBehaviour : MonoBehaviour, IPointerClickHandler, IRoomResettable
```

### 修改2：OnPointerClick 方法体第一行加交互屏蔽

```csharp
public void OnPointerClick(PointerEventData eventData)
{
    if (!GameManager.InteractionEnabled) return; // 加这一行，必须是第一行
    // 原有逻辑完全不变
}
```

## 各脚本的 ResetRoom 方法（加在类的末尾）

### KidBehaviour（BoyAnimControl.cs）

该脚本没有 idle 循环协程，不需要重启协程。

```csharp
public void ResetRoom()
{
    StopAllCoroutines();
    isPlaying = false;
    hasCompleted = false;
    animator.Rebind();
    animator.Update(0f);
}
```

### OldWomanTalk（OldWoman.cs）

该脚本没有 idle 循环协程，不需要重启协程。

```csharp
public void ResetRoom()
{
    StopAllCoroutines();
    isPlaying = false;
    hasCompleted = false;
    animator.Rebind();
    animator.Update(0f);
}
```

### CoupleRoom（TalkComplain.cs）

注意三点：有两个 Animator；被 SetActive(false) 隐藏的舞者需要恢复显示；clickCount 需要清零。

```csharp
public void ResetRoom()
{
    StopAllCoroutines();
    isPlaying = false;
    clickCount = 0;

    foreach (GameObject person in batch1)
        person.SetActive(true);
    foreach (GameObject person in batch2)
        person.SetActive(true);

    couple1Animator.Rebind();
    couple1Animator.Update(0f);
    couple2Animator.Rebind();
    couple2Animator.Update(0f);
}
```

### ToiletMan（ToiletMan.cs）

注意：有两个 Animator（自身 animator 和 public 的 windowAnimator），isOpen 初始值是 true。

```csharp
public void ResetRoom()
{
    StopAllCoroutines();
    isOpen = true;
    animator.Rebind();
    animator.Update(0f);
    if (windowAnimator != null)
    {
        windowAnimator.Rebind();
        windowAnimator.Update(0f);
    }
}
```

### BotherWorker（WorkManControl.cs）

注意：有 RandomIdleLoop 循环协程，Rebind 之后必须重启。

```csharp
public void ResetRoom()
{
    StopAllCoroutines();
    isAngry = false;
    hasCompleted = false;
    animator.Rebind();
    animator.Update(0f);
    StartCoroutine(RandomIdleLoop());
}
```

## 技术说明

- `animator.Rebind()` 重置 Animator 所有参数和状态，状态机回到 Entry 默认状态，不需要手动清每个 Animator Parameter。
- `animator.Update(0f)` 让 Rebind 立即生效，避免下一帧残留旧姿势。
- `StopAllCoroutines()` 停掉该 MonoBehaviour 上所有协程，所以有循环协程的脚本（BotherWorker）必须在最后重新 StartCoroutine。
- `hasCompleted` 一并清零是有意为之：screensaver 退出后下一个观众从零开始体验。

## 验收标准

每个脚本改完后应满足：

1. 类声明包含 `IRoomResettable`
2. `OnPointerClick` 第一行是 `if (!GameManager.InteractionEnabled) return;`
3. 有完整的 `ResetRoom()` 方法且内容与上方对应
4. 没有改动任何其他逻辑
5. 编译无报错