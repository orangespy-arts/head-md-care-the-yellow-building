

**The Yellow Building — Production Plan v6**
*Updated: June 9, 2026*

---

**Team & Responsibilities**

**zhanlan**
Character model generation, rigging, animation sourcing and binding, interaction scripts, text assets (AngerWords, Complain, TalkOnPhone subtitles)

**lisa**
Furniture asset collection, scene assembly, building materials, lighting, sound effect import and room mounting

**gold** *(no longer available)*
Tasks redistributed to zhanlan and lisa as above

---

**Completed**

**June 1** — zhanlan: all 15 character models generated, rigged, and validated. lisa: furniture placement for A1, A2, B1, B3, moodboard, color palette, UX flow documentation.

**June 2** — zhanlan: all 15 models imported with Humanoid Rig, motion capture for A1, A2, B1, B2, C2, C3 (23 states). lisa: participated in C3 mocap, imported models, placed furniture for B1, B3, C3, updated window models.

**June 3** — zhanlan: trimmed and organized all animations, completed C2 dancer pipeline (binding, materials, duplication to nine dancers), finalized interaction system architecture. lisa: furniture placement for A3 and C2, built opposing building view.

**June 4** — zhanlan: completed RoomA2 (WorkMan) interaction end to end, established reusable Pattern A (random idle + click-triggered one-shot), documented Animator and coroutine pitfalls.

**June 5** — zhanlan: completed RoomB1 (Boy), RoomB2 (OldWoman), RoomA1 (ToiletMan), established reusable Pattern B (sequence rooms via Has Exit Time). Began migration from GreyBoxing to Final; click issue after migration deferred.

**June 8–9** — zhanlan: completed RoomC3 couple interaction (two-click sequence, synchronized dual Animator, AnyState structure), completed C2 dancer-reduction linkage (batch disappearance with public timing parameters). Began A3 cat screensaver mode: jump loop logic written, position/orientation bug pending. lisa: completed scene assembly for all nine rooms, created C3 banner model.

---

**Status Summary (as of June 9)**

Rooms complete (5/7): A1, A2, B1, B2, C3+C2 linkage — interaction working in GreyBoxing

Rooms remaining (1/7): A3 (cat screensaver mode, jump loop written but position/orientation bug pending)

Scene assembly: all nine rooms complete (lisa)

Core system: redesigned from original GameManager/CameraController/ClickDetector trio to a two-mode architecture (default mode and screensaver mode); not yet written

Open issues: cat position/orientation after teleport broken; Toon Shader not yet configured (dancer disappearance currently SetActive, fade-out deferred); post-migration click issue in Final project unresolved; text assets (AngerWords, Complain, TalkOnPhone) not yet written; audio not yet imported

---

**June 10 (Wednesday)**
**zhanlan:** Fix cat position and orientation (test with Quaternion.identity, verify CatBalcony marker points). Write text assets (AngerWords x3, Complain x3, TalkOnPhone subtitles). Begin Core system (default mode / screensaver mode architecture)
**lisa:** Begin importing audio assets, begin lighting

**June 11 (Thursday)**
**zhanlan:** Complete Core system. Wire all rooms' ReportCompletion into mode manager. Begin full interaction integration in Final project
**lisa:** Continue lighting, continue audio import

**June 12 (Friday)**
**zhanlan + lisa:** Full scene integration in Final. Run through all interactions in both modes. Record bug list. Resolve post-migration click issue

**June 13 (Saturday)**
**zhanlan + lisa:** Bug fixing round one. Configure Toon Shader, switch dancer disappearance to fade-out

**June 14 (Sunday)**
**zhanlan + lisa:** Bug fixing round two. Buffer

**June 15 (Monday)**
Presentation run-through. PDF deadline 12:00 *(owner TBD)*

**June 16 (Tuesday)**
Final Presentation

---

**Key Changes from v5**

- Gold no longer available; text assets redistributed to zhanlan, audio and sound effect import redistributed to lisa
- All nine room scenes completed by lisa (June 8–9), ahead of the v5 schedule
- C3/C2 linkage completed (June 8–9), one session later than v5 planned
- A3 cat redesigned from interactive object to screensaver trigger; jump loop written but position/orientation bug unresolved; screensaver enter/exit and camera FOV push-in not yet built
- Core system architecture changed from original three-component trio to a two-mode design (default / screensaver); implementation deferred to June 11
- Schedule remains tight: Core system, Final integration, bug fixing, and Toon Shader configuration all compressed into June 11–14
- PDF owner not yet decided; deadline remains June 15 at 12:00