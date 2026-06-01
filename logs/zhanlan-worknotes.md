# The Yellow Building — Zhanlan Work Summary

## My Responsibilities
- Character model generation (Ready Player Me)
- Rig binding for all six characters
- Motion capture recording
- Animation binding (mocap data cleanup, retargeting, binding)
- Sound effect import into Unity, mount to corresponding rooms
- All seven interaction scripts

---

## Hard Deadlines
- **June 2** — All six character rigs complete
- **June 3** — Motion capture day
- **June 5** — All animation binding complete
- **June 8** — All sound effects imported and mounted in Unity (before scripting begins)
- **June 10** — All scripts complete
- **June 11** — Full scene integration with Lisa

---

## Daily Plan

**June 1 (Monday)**
Generate six character models on Ready Player Me, export FBX
- OldWoman
- Kid
- Couple1
- Couple2
- WorkMan
- ToiletMan

**June 2 (Tuesday)**
Complete rig binding for all six characters
Use Mixamo to verify rig compatibility

**June 3 (Wednesday) — Motion Capture Day**
Record with Lisa using Perception Neuron
Order: Kid → OldWoman → Couple → WorkMan → ToiletMan → Dance
If dance runs out of time, use Mixamo directly

**June 4 (Thursday)**
Mocap data cleanup and retargeting in Axis Studio + Blender
Begin animation binding in Unity

**June 5 (Friday)**
Complete all animation binding
Integrate cat animation (existing asset)

**June 6 (Saturday)**
Buffer day — catch up on anything unfinished

**June 8 (Monday)**
Receive all audio files from Gold
Import all sound effects into Unity
Mount each sound to its corresponding room
Must be fully complete before scripting begins

**June 9 (Tuesday)**
Write scripts: RoomA1, RoomA2, RoomA3

**June 10 (Wednesday)**
Write scripts: RoomB1, RoomB2, RoomC3, RoomC2 cross-room interaction

**June 11 (Thursday)**
Full scene integration with Lisa
Run through all interactions
Record bug list

**June 12 (Friday)**
Bug fixing round one with Lisa

**June 13 (Saturday)**
Bug fixing round two (solo)

**June 14 (Sunday)**
Final testing, prepare demo version

**June 15 (Monday)**
Presentation run-through

**June 16 (Tuesday)**
Final Presentation

---

## Scripts Overview
| Room | Logic |
|------|-------|
| RoomA1 | Click window → ToiletMan screams, window closes, flush sound plays |
| RoomA2 | Click x1 light dims, gesture changes; click x3 anger text appears, resets after 3s |
| RoomA3 | Click cat → jumps to random window, ends at B2 balcony eating food |
| RoomB1 | Click window → Kid looks up with random gesture 2-3s, moving boxes appear |
| RoomB2 | Click window → OldWoman talks on phone, plays podcast audio in sequence 1-3 |
| RoomC3 | Click window → Couple complains, -2 persons in C2, music fades to silence, resets after 10s |
| RoomC2 | No independent script, reacts to RoomC3 |

---

## Animation List
| Room | Animations |
|------|-----------|
| RoomA1 | WindowOpen, WindowClose, SitOnToilet, PeopleCloseWindow |
| RoomA2 | FocusOnComputer, HandsPutUnderFaceThinking, AngryTalking |
| RoomA3 | CatAnim |
| RoomB1 | KidUp, KidDown, KidWaveHand, KidUpRightWindow, KidUpLeftWindow |
| RoomB2 | OldWomanSit, OldWomanTalkPhone1, OldWomanTalkPhone2, OldWomanTalkPhone3 |
| RoomC2 | AfterDanceStand, TalkWithCouple, Dance1-12 |
| RoomC3 | StickBannerOnWindow, CoupleTalk1.1, CoupleTalk2.1, CoupleComplain1, CoupleComplain2, CoupleTalk1.2, CoupleTalk2.2 |

---

## Sound Effects to Import (June 8)
| Room | Files |
|------|-------|
| RoomA1 | ToiletFlush, Scream, Clip |
| RoomA2 | TypeComputer |
| RoomA3 | CatMiao1, CatMiao2, CatMiao3 |
| RoomB2 | Podcast1, Podcast2, Podcast3 |
| RoomC2 | DanceMusic, PeopleLaughTalk |

---

## Technical Stack
- Character generation: Ready Player Me
- Mocap device: Perception Neuron
- Mocap software: Axis Studio
- Data cleanup: Blender
- Engine: Unity (Humanoid Avatar, Animator Controller)
- Dance animations fallback: Mixamo