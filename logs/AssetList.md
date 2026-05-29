# Asset list

## Room assets
```
Hierarchy
├──RoomA1/
├──RoomA2/
├──RoomA3/
├──RoomB1/
├──RoomB2/
├──RoomB3/
├──RoomC1/
├──RoomC2/
└──RoomC3/


Assets/
├──Animations/
    ├──RoomA1/
        ├──WindowOpen
        ├──WindowClose
        ├──SitOnToilet
        ├──PeopleCloseWindow
    ├──RoomA2/
        ├──FocusOnComputer
        ├──HandsPutUnderFaceThinking
        ├──AngeryTalking
    ├──RoomA3/(Cat Start from here)
        ├──CatAnim
    ├──RoomB1/
        ├──KidUp
        ├──KidDown
        ├──KidWaveHand
        ├──KidUpRightWindow
        ├──KidUpLeftWindow
    ├──RoomB2/
        ├──OldWomanSit
        ├──OldWomanTalkPhone1
        ├──OldWomanTalkPhone2
        ├──OldWomanTalkPhone3
    ├──RoomB3/(No animation)
    ├──RoomC1/(No animation)
    ├──RoomC2/
        ├──AfterDanceStand
        ├──TalkWithCouple
        ├──Dance1
        ├──Dance2
        ├──Dance3
        ├──Dance4
        ├──Dance5
        ├──Dance6
        ├──Dance7
        ├──Dance8
        ├──Dance9
        ├──Dance10
        ├──Dance11
        ├──Dance12
    └──RoomC3/
        ├──StickBannerOnWindow
        ├──CoupleTalk1.1(Before complain)
        ├──CoupleTalk2.1
        ├──CoupleComplain1
        ├──CoupleComplain2
        ├──CoupleTalk1.2(After complain)
        ├──CoupleTalk2.2
  
├──Materials/
  
├──Models/
    ├──Building
        ├──Windows
        ├──Wall
        ├──Rooms
    ├──RoomA1/
        ├──People/
            ├──ToiletMan
        ├──Furniture/(Minimal Toilet style)
            ├──Toilet
            ├──ToiletPaper
            ├──Mirror
            ├──Lavabo
    ├──RoomA2/
        ├──People/
            ├──WorkMan
        ├──Furniture/
            ├──Desk
            ├──Book
            ├──Document
            ├──Keyborad
            ├──Computer
            ├──Coffee
            ├──DeskLamp
            ├──BookShelf
            ├──Chair
    ├──RoomA3/
        ├──Furniture/
            ├──Sofa
            ├──Table
            ├──Plants
    ├──RoomB1/
        ├──People/
            ├──Kid
        ├──Furniture/
            ├──Bear
            ├──Toy
            ├──PuzzleGame
            ├──Carpet
            ├──PackageBoxes
    ├──RoomB2/
        ├──People/
            ├──OldWoman
        ├──Furniture/
            ├──Sofa
            ├──Phone
            ├──PlantsOutWindow
            ├──CatFood
    ├──RoomB3/
    ├──RoomC1/
        ├──PackageBoxes
        ├──Lamp
    ├──RoomC2/
        ├──Lamp
    └──RoomC3/(bedroom for couple)
        ├──People
            ├──Couple1
            ├──Couple2
        ├──Furniture
            ├──Bed
            ├──Lamp
            ├──Painting

├──Scenes/
│  ├──YellowBuilding

├──Sounds/
    ├──RoomA1/
        ├──ToiletFlush(sound after close the window)
        ├──Scream(from the people close the window)
        ├──Clip(windows clip)
    ├──RoomA2/
        ├──TypeComputer
    ├──RoomA3/(random trigger)
        ├──CatMiao1
        ├──CatMiao2
        ├──CatMiao3
    ├──RoomB2/
        ├──Podcast1
        ├──Podcast2
        ├──Podcast3
    ├──RoomC2/
        ├──DanceMusic
        ├──PeopleLaughTalk

├──Texts/
    ├──RoomA2/
        ├──AngerWords1
        ├──AngerWords2
        ├──AngerWords1
    ├──RoomB2/
        ├──TalkOnPhone(The content to show it is playing podcast)
    └──RoomC3/
        ├──Complain1
        ├──Complain2
        ├──Complain3

└──Scripts/
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
```


