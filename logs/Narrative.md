另外 我还想到一个点，我想讨论一下 整个叙事。首先 这是一个yellow building, 这个场景是从另一栋楼的一扇窗望出去的，且这个是开始的画面。（图1）
最开始的画面，是一个人的房间，有床，植物，（后面窗边 的场景会加上一只猫和一杯水。（图1）
交互方式1的开始：点击这杯水，一只手伸出来拿走这杯水，场景Zoom in 到图2，9个房间的视角，然后开始我的这些交互，用户可以自由点击
 ├──RoomA1/
        WindowClose(Click this window, ToiletMan scream, close the window and play FlushSound)
    ├──RoomA2/
        BotherWorker(Click this window, one click light go down(after it all dark reset) Worker man change gesture, after 3 times click, he say the angery words in text, then after 3s, go back)
    ├──RoomA3/
        CatBehavivour(Click the cat, it jumps to a random window, with animation, eat food at B2 balcony)
    ├──RoomB1/
        KidBehaviour(Click this window, Kid head up in random gestures with different animations, maintain 2-3s go down, and boxes show up, means he left)
    ├──RoomB2/
        OldWomanTalk(Click this window, old woman talk with phone and play the podcast sounds in sequence from 1-3)
    ├──RoomC2/
        (no script, but interact with RoomC3)
    └──RoomC3/
        Complain(Click this window, the couple compain the dancing people, then -2 persons in RoomC2, music become quieter till the end 0 music, after 10s reset everything)

    备注：可能点击的对象不是窗户本身，也可以是其他的，待定

    交互方式2：在最开始的场景（图1），点击那只猫，猫从窗户跳出去，跳到对面楼其中一个阳台，用户的视线跟着那只猫一起探索，但摄像机的角度不变，一直是正着的视角，但放大视角（图三）然后猫又窜到下一个阳台，又是同一相机角度的其他场景。但这个所有交互 还是这些点击一个东西 触发一些行动，（这就是我在纠结的点，点击的对象不是窗户，因为图三的视角窗户太大了，所以考虑点击这里面的人本身）

    我的问题是，如何以最少的代码 简单的逻辑 实现这两个交互方式
