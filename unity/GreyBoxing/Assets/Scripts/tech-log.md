# The Yellow Building — Claude Code 工作文档
## 更新于 June 11, 2026

---

## 项目背景

Unity 交互装置，6月16日终展。从对面楼窗口望出去看一栋黄色建筑里九个房间的居民生活。3渲2（URP Toon Shader）。

**团队分工：**
- Orangespy：scripting / animation / rigging
- Lisa：assets / scene / 音频导入
- zhanlan：文字资产 / 叙事方向

---

## 场景结构

九个房间排列在 3x3 网格：

```
A1(ToiletMan)  A2(WorkMan)  A3(Cat起始)
B1(Boy)        B2(OldWoman) B3
C1             C2(舞者)     C3(Couple)
```

---

## 当前脚本清单（June 11 回滚后实际状态）

| 文件路径 | 类名 | 挂载位置 | 用途 |
|---|---|---|---|
| Scripts/BoyAnimControl.cs | KidBehaviour | B1 人物 | Boy 交互 |
| Scripts/Cat.cs | CatController | CatModel | 猫跳跃逻辑 |
| Scripts/TalkComplain.cs | CoupleRoom | C3 Couple parent | Couple 交互 |
| Scripts/KidHeadOut.cs | — | — | 旧版 Boy 脚本（废弃） |
| Scripts/cat_jump.cs | — | — | 旧版猫脚本（废弃） |
| Scripts/complain.cs | — | — | 旧版 Couple 脚本（废弃） |
| Characters-Anim-Script/A1-ToiletMan/ToiletMan.cs | ToiletMan | A1 人物 | ToiletMan 交互 |
| Characters-Anim-Script/A2-WorkMan/WorkManControl.cs | BotherWorker | A2 人物 | WorkMan 交互 |
| Characters-Anim-Script/B2-OldWoman/OldWoman.cs | OldWomanTalk | B2 人物 | OldWoman 交互 |

**注意：文件名和类名在多个脚本中不一致，以上表格为准。**

**不存在的脚本（需要重建）：**
- `GameManager.cs` — 已随 0610update 回滚删除
- `CameraController.cs` — 已随 0610update 回滚删除

---

## June 11 — 重要决定

### 0610update 整体回滚
由于项目运行问题，将 `c208e6f 0610update` commit 整体 revert（新建 `b0254b9 Revert "0610update"`）。

**被回滚的内容：**
- GameManager.cs（双模式架构、IRoomResettable 接口、Screensaver 逻辑）
- CameraController.cs（推进 + 猫跟随）
- 所有房间脚本升级版（GameManager.InteractionEnabled、ResetRoom 接口）
- Cat.cs 的抛物线跳跃、facingTarget 系统
- tech-log.md、Production-plan-v7.md、ProductionLog-06-10.md

**根因（事后诊断）：** 卡死不是脚本问题，是 `manifest.json` 里 `com.unity.ai.assistant@2.9.0-pre.1` 在无限循环请求网络授权（每次请求在国内网络下等待超时，累计卡住主线程）。建议以后新建项目时删除这个包。

### 放弃浮动文字框系统
不再实现 `FloatingText.cs` 及三个房间的台词显示功能。`FloatingText.cs` 为遗留未跟踪文件，可删除。

---

## 当前房间脚本状态概览

所有脚本目前**没有** GameManager 集成（无交互屏蔽、无 ResetRoom），是独立的单房间逻辑。

### TalkComplain.cs（CoupleRoom / C3）
- 点击两次，每次触发对应动画 + 让 batch 人物消失
- `disappearAt` 控制消失时机（动画进度的百分比）
- `disappearInterval` 控制每个人物消失的间隔

### WorkManControl.cs（BotherWorker / A2）
- 随机 idle 循环（State 1/2/3）
- 点击触发 Angery 动画，动画结束后自动回 idle

### OldWoman.cs（OldWomanTalk / B2）
- 点击触发拿电话动画序列（02-PickUpPhone → 01-Sit）
- 播放期间不响应重复点击

### BoyAnimControl.cs（KidBehaviour / B1）
- 点击触发随机抬头动画（WaveIndex 3/4/5）
- 动画结束后解锁

### ToiletMan.cs（A1）
- 点击切换 Closed bool，驱动窗户开关动画

### Cat.cs（CatController / A3 起始）
- 随机跳到有效窗台（同列不能跳，行差 ≤1）
- 当前版本：跳跃结束后瞬移到目标位置（抛物线系统在回滚中丢失）

---

## 剩余工作（优先级顺序）

1. Final 工程整合（迁移后点击失效问题）
2. Toon Shader 配置：舞者消失改淡出
3. 决定是否重建 GameManager / Screensaver 系统
