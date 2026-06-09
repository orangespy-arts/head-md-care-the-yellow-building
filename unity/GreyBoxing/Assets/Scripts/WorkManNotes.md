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

Loop Time
四个 clip 的 Loop Time 必须取消勾选。如果勾着，动画的 normalizedTime 会一直在 0 到 1 之间循环，永远到不了 1，脚本里所有 WaitUntil(normalizedTime >= 1f) 的判断都会卡死。这次 03-Think 卡住、Angery 播完不结束，都和这个有关。
经验：凡是用 normalizedTime >= 1 判断"动画播完"的，对应的 clip 一定要关 Loop Time。如果某个动画确实需要循环（比如持续的 idle 待机），那就不能用 normalizedTime 判断结束，要改用别的方式（比如按时长 WaitForSeconds，或者干脆让它一直循环不判断结束）。
Can Transition To Self（itself）
AnyState 转换默认勾着 Can Transition To Self。它的意思是"允许从自己转换到自己"。问题在于 AnyState 转换每帧都检测条件，如果 State == 2 一直成立，它每帧都满足"切到 02-Sit"，于是不断打断当前的 02-Sit 重新进入，动画永远停在开头。
经验：用 AnyState 做状态切换时，如果目标状态的触发条件在状态持续期间一直成立（比如基于一个不变的 int 值），就必须关掉 Can Transition To Self，否则会自我打断重播。这次三条 AnyState → idle 的线都要关。

**给后面六个房间的经验**

这套 idle 随机循环 + 点击触发一次性动作的模式，A1、B1 等点一次完成的房间都能复用，只是触发的目标动画不同。最容易踩的坑是：AnyState 转换的 Can Transition To Self、多余的 condition、bool 没及时清。下次连完线先检查这三点，能省很多时间。

需要我把这些更新进 CHANGELOG.md 和 DECISIONS.md 吗？A2 的几个决策（比如用 AnyState + bool 触发一次性动作、idle 由脚本而非 Animator 驱动）值得记下来，后面房间直接照搬。