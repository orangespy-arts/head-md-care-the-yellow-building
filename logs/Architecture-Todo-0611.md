# 四状态架构 TODO（June 16 终展）
## 进度更新于 June 11 下午

```
State1 Screensaver ──点击──▶ State2 Interactive ──全部完成 或 闲置45s──▶
State3 Dissolving（自动消失）──▶ State4 Ending（zoom out·猫·变黑）──▶ 回 State1
```

**原则：一步一个阶段，每阶段结束必须在 Unity 里验证通过 + git commit，才进下一阶段。**

---

## ▶️ 重启回来从这里继续（当前焦点：阶段 5 内容与打磨）

阶段 3、4 已完成，四状态循环跑通。下一步进入 **阶段 5（内容与打磨）**：

1. Toon Shader：舞者消失改材质淡出（替换 State3 现在的 SetActive）
2. 音频接入（Lisa 素材）+ podcast 字幕节奏对齐
3. Final 工程整合 + 迁移后点击失效排查
4. 参数定稿，**关掉 Debug Skip Screensaver、idle 阈值回 45**
5. Windows Build 全屏 + 压力测试 + 展期硬性检查

---

## ✅ 阶段 0 — 基线确认（06-11 完成）

- [x] 猫动画恢复正常（0610 状态 reapply：`636e32d`，Humanoid rig + controller + 抛物线全回来了）
- [x] 帧率问题解决（根因是 com.unity.ai.assistant 预发布包的网络授权死循环，已移除，commit `d424436 0611change1`）

## ✅ 阶段 1 — 状态机二态 → 四态（06-11 完成，commit `0611 State1` / `0611State1.2`）

- [x] `GameState { Screensaver, Interactive, Dissolving, Ending }`，开机即 Screensaver
- [x] CameraController 同步改名
- [x] RegisterInteractive / ReportCompletion API 就位
- [x] State3/4 占位循环验证通过（四状态流转 + 重置回屏保）

## ✅ 阶段 2 — 完成上报接入（06-11 完成，用户已 commit）

- [x] 五个房间注册 + 完成上报（A1 点击 / A2 Angery / B1 抬头 / B2 电话 / C3 两次点击）
- [x] ReportCompletion 去重防御（反复点击不重复计数）
- [x] 验证通过：n/5 计数 + 全完成触发消失路径

## ✅ 阶段 3 — State3 消失系统（06-11 完成）

- [x] ~~RoomContents.cs~~ **设计变更**：改为 GameManager 上 `rooms[9]`（`GameObject[]`），拖 empty 父物体，
      直接子物体按层级顺序逐个消失（`objectInterval`），房间间隔 `roomDissolveInterval` 可重叠
- [x] 初始 active 状态记忆（本来关着的道具重置时不会被错误打开）
- [x] Cat.cs 加 `Hide()` / `ResetCat()`
- [x] 测试开关 `debugSkipScreensaver`（Inspector 勾选直接进 Interactive）⚠️ **上展前必须关掉 + 阈值回 45**
- [x] 场景里九个房间的 empty 父物体结构搭对（要消失的模型为直接子物体）
- [x] 验证消失节奏 + 连跑两圈复原正常
- [x] ✅ commit

## ✅ 阶段 4 — State4 结尾（06-11 完成）

- [x] Lisa 的建筑已到：`DavinRoom-clean.unitypackage` 已导入（Building/EmptyRoom.prefab、Room.prefab、window-2、全套家具）
      ※ 原包是 Mac 重打包导致解压失败，已修复并剔除了危险的脚本副本和 HDRP 示例（24 个）
- [x] 场景搭结尾房间 + 放 `endingView`（机位空物体，含朝向）+ `endingCatPerch`（窗台猫位）
- [x] CameraController 加 Ending 机位（position + rotation 双 lerp）
- [x] Cat.cs 加 `AppearAt(perch)`
- [x] 变黑：GameManager 渐暗 `sunLight` + 全屏黑 Canvas（CanvasGroup，重置时无跳变）
- [x] ResetAll 加灯光复原 → 回 State1
- [x] 验证：完整四状态循环连跑 3 圈无异常
- [x] ✅ commit

## 阶段 5 — 内容与打磨（06-14~15）

- [ ] Toon Shader：舞者消失改材质淡出（State3 的 SetActive 升级版）
- [ ] 音频接入（Lisa）：OldWoman podcast 1-3、ToiletMan FlushSound、C2 音乐随 Couple 抱怨渐弱
      ※ podcast 法文转录稿（法/英/中对照）在 `media/podcast-origin-transcript.md`
- [ ] Final 工程整合：迁移后点击失效排查（EventSystem 用 InputSystemUIInputModule、相机挂 Physics Raycaster、物体有 Collider）
- [ ] 参数定稿：idle 阈值 45s、allCompleteDelay、消失节奏、变黑/全黑/淡出时长
- [ ] **关掉 Debug Skip Screensaver**
- [ ] 展览压力测试：无人值守连续循环 30 分钟，确认无累积错误、无内存增长

## 展期硬性检查（06-15 晚前必须全过）

- [ ] **Windows Build** 全屏测试（不能只信编辑器）
- [ ] 展场设备实测触控板/触摸屏点击
- [ ] 开机自启动方案（开机 → 自动全屏进 State1）
- [ ] 断电恢复演练：拔电重启后 5 分钟内恢复展示

---

## 时间轴（按 06-11 实际进度修订）

| 日期 | 目标 | 状态 |
|---|---|---|
| 06-11 | 阶段 0+1+2+3+4 全部 ✅（四状态循环跑通） | 大幅超前于原计划 |
| 06-12 | 阶段 5 起步（淡出、音频、整合） | |
| 06-13 | 阶段 5 推进 + 完整循环验证 | |
| 06-14 | 阶段 5（淡出、音频、整合）收尾 | |
| 06-15 | 参数定稿 + Build + 压力测试 + 展期检查 | |
| 06-16 | 终展 🎪 | |

---

## 备忘

- commit 一律由 zhanlan 自己执行（命名习惯：`0611State1` 这类）
- git 历史：`636e32d Reapply 0610update`（猫恢复）← `d424436 0611change1`（AI 包移除）← `b0254b9 Revert`（已作废的回滚）
- 四状态完整参考实现备份：`D:\Github\yellowbuilding-backup-0611\`（旧文件结构，参考逻辑勿整文件覆盖）
- Lisa 以后导出 unitypackage：用 Unity 自带 Export、取消勾选 Scripts 和 Samples、不要用 Mac 压缩工具二次处理
