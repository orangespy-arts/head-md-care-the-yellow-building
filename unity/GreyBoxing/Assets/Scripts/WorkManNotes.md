好，A2 跑通了。把整个过程的问题和最终设置总结如下，给后面六个房间做参考。

**遇到的问题和原因**

第一，点击没反应。原因是 `IPointerClickHandler` 需要三个东西同时存在：角色上有 Collider、相机上有 Physics Raycaster、场景里有 EventSystem。

第二，idle 动画卡在开头不停重播。原因是 AnyState 转换默认会自我打断，State 值不变时每帧都满足条件，不断重新进入同一状态。解决办法是关掉这三条 AnyState → idle 转换的 Can Transition To Self。

第三，读动画长度读到错值导致卡住。原因是在状态刚切换的同一帧就读 length，这时还在过渡中。解决办法是先 `WaitUntil(!animator.IsInTransition(0))` 等过渡结束再读。

第四，点击不进 Angery。原因是 `AnyState → 04-Angery` 多了一个 `State Equals 4` 的 condition，和 `Angery == true` 是 AND 关系，永远不成立。解决办法是删掉这个 condition，只留 `Angery == true`。这个问题出现了两次，第二次是删除操作没生效。

第五，播完 Angery 在 1 和 4 之间循环。原因是 bool 没及时清，播完跳回 01 时 Angery 还是 true，又被抓回 4。解决办法是给 `04-Angery → 01` 加 `Angery == false` 的 condition，让它播完后停住等脚本清 bool 再跳回。

**最终的 Animator 设置（A2 WorkMan-Controller）**

参数：`State`（int）、`Angery`（bool）。

状态：01-UseComputer（默认）、02-Sit、03-Think、04-Angery，四个 clip 全部取消 Loop Time。

转换：

AnyState → 01-UseComputer，condition `State==1 && Angery==false`，Has Exit Time 关，Can Transition To Self 关。

AnyState → 02-Sit，condition `State==2 && Angery==false`，同上。

AnyState → 03-Think，condition `State==3 && Angery==false`，同上。

AnyState → 04-Angery，condition 只有 `Angery==true`，Has Exit Time 关。

04-Angery → 01-UseComputer，condition `Angery==false`，Has Exit Time 勾。

**GameObject 上的组件**

workMan 上需要：Animator（挂 WorkMan-Controller）、Box Collider（罩住角色可见部分）、BotherWorker 脚本。相机上需要 Physics Raycaster。场景里需要 EventSystem。

**给后面六个房间的经验**

这套 idle 随机循环 + 点击触发一次性动作的模式，A1、B1 等点一次完成的房间都能复用，只是触发的目标动画不同。最容易踩的坑是：AnyState 转换的 Can Transition To Self、多余的 condition、bool 没及时清。下次连完线先检查这三点，能省很多时间。

需要我把这些更新进 CHANGELOG.md 和 DECISIONS.md 吗？A2 的几个决策（比如用 AnyState + bool 触发一次性动作、idle 由脚本而非 Animator 驱动）值得记下来，后面房间直接照搬。