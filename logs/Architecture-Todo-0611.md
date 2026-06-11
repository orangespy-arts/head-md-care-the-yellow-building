# 四状态架构 TODO（June 11 → 终展 June 16）

```
State1 Screensaver ──点击──▶ State2 Interactive ──全部完成 或 闲置45s──▶
State3 Dissolving（自动消失）──▶ State4 Ending（zoom out·猫·变黑）──▶ 回 State1
```

**原则：一步一个阶段，每阶段结束必须在 Unity 里验证通过 + git commit，才进下一阶段。**
**参考代码：四状态完整实现备份在 `D:\Github\yellowbuilding-backup-0611\`（基于另一版文件结构，迁移时参考逻辑、不要整文件覆盖）。**

---

## 阶段 0 — 基线确认（今天，06-11）

- [ ] 插电 + 重启 Unity，等导入完，确认猫动画恢复正常、帧率正常
- [ ] Play mode 全功能过一遍：五个房间点击交互、screensaver 进出（60s idle）、猫抛物线跳跃
- [ ] `git status` 确认干净（Unity 重新生成的文件不污染仓库）
- [ ] ✅ 通过后 commit：`0611 baseline verified`

## 阶段 1 — 状态机二态 → 四态（只动 GameManager.cs）

- [ ] `GameMode { Default, Screensaver }` 改为 `GameState { Screensaver, Interactive, Dissolving, Ending }`
  - 旧 Default ≈ 新 Interactive；**起始状态从 Default 改为 Screensaver**（展览开机即吸引模式）
  - CameraController 里的 `GameMode` 引用同步改名
- [ ] 加房间注册/上报 API：`RegisterInteractive(id)` / `ReportCompletion(id)`（先空着 Dissolving/Ending 分支）
- [ ] State2 闲置不再回 Screensaver，而是预留进 State3（先打 Debug.Log 占位）
- [ ] 验证：State1↔State2 进出和昨天 screensaver 行为完全一致
- [ ] ✅ commit

## 阶段 2 — 完成上报接入（五个房间脚本，每个 +2 行）

- [ ] 五个脚本 `Start()` 里注册；已注释的 `ReportCompletion` 打开
  - 完成标准：ToiletMan=点击1次 / WorkMan=Angery播完 / OldWoman=电话序列播完 / Boy=抬头播完 / Couple=两次点击都走完
- [ ] 验证：Console 出现「房间完成 n/5」计数，全点完时打出全完成 log
- [ ] ✅ commit

## 阶段 3 — State3 消失系统

- [ ] 新建 `RoomContents.cs`（roomId + objects[] + 逐个 SetActive(false)，与交互脚本解耦）
- [ ] 九个房间根物体都挂上（含无交互的 B3/C1/C2），把要消失的物体按顺序拖进去
- [ ] GameManager 实装 DissolveSequence：逐房间消失 → 猫 Hide() → 进 State4
- [ ] Cat.cs 加 `Hide()`（停跳 + 关 Renderer）
- [ ] 验证：idle 阈值临时调 5 秒，看消失节奏；调 `roomDissolveInterval` / `objectInterval` 到满意
- [ ] ✅ commit

## 阶段 4 — State4 结尾（依赖场景资产，提前和 Lisa 对齐）

- [ ] **Lisa：结尾房间场景** —— 对面楼室内（窗框 + 窗台），机位能看到整栋黄楼 ⚠️ 关键路径，越早越好
- [ ] 场景放 `endingView`（机位空物体，含朝向）+ `endingCatPerch`（窗台猫位）
- [ ] CameraController 加 Ending 机位（position + rotation 双 lerp）
- [ ] Cat.cs 加 `AppearAt(perch)` / `ResetCat()`
- [ ] 变黑：GameManager 渐暗 `sunLight` + 可选全屏黑 Canvas（CanvasGroup，推荐做，重置时无跳变）
- [ ] ResetAll：黑屏中复原全部房间/猫/灯光 → 回 State1
- [ ] 验证：完整四状态循环连跑 3 圈无异常
- [ ] ✅ commit

## 阶段 5 — 内容与打磨（06-14~15）

- [ ] Toon Shader：舞者消失改材质淡出（State3 的 SetActive 升级，全局淡出更梦幻可顺延此方案）
- [ ] 音频接入（Lisa）：OldWoman podcast 1-3、ToiletMan FlushSound、C2 音乐随 Couple 抱怨渐弱
- [ ] Final 工程整合：迁移后点击失效排查（检查 EventSystem 用 InputSystemUIInputModule、相机挂 Physics Raycaster、物体有 Collider）
- [ ] 参数定稿：idle 阈值（建议 45s）、allCompleteDelay、消失节奏、变黑/全黑/淡出时长
- [ ] **展览压力测试：无人值守连续循环 30 分钟**，确认无累积错误、无内存增长

## 展期硬性检查（06-15 晚前必须全过）

- [ ] 做一个 **Windows Build** 全屏测试（不能只信编辑器！build 后帧率和点击行为都可能不同）
- [ ] 展场设备上测触控板/触摸屏点击（Pointer.current 已覆盖，但要实测）
- [ ] 开机自启动方案（开机 → 自动全屏进 State1）
- [ ] 断电恢复演练：拔电重启后 5 分钟内能恢复展示

---

## 时间轴建议

| 日期 | 目标 |
|---|---|
| 06-11（今天） | 阶段 0 + 阶段 1 |
| 06-12 | 阶段 2 + 阶段 3 |
| 06-13 | 阶段 4（Lisa 的结尾房间今天必须能用） |
| 06-14 | 阶段 5 前半（淡出、音频、整合） |
| 06-15 | 参数定稿 + Build + 压力测试 + 展期检查 |
| 06-16 | 终展 🎪 |
