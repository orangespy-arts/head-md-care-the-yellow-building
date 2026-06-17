---

**The Yellow Building — Production Plan v5**
*Updated: June 5, 2026*

---

**Team & Responsibilities**

**zhanlan**
Character model generation, rigging, animation sourcing and binding, sound effect import and room mounting, all interaction scripts

**lisa**
Furniture asset collection, scene assembly, building materials, lighting

**gold** *(unable to sit for extended periods, working in short sessions only)*
All audio content selection and editing (sound effects, podcast, dance music), text assets (AngerWords, Complain, TalkOnPhone subtitles), presentation PDF
Gold starts work on June 4 (Thursday)

---

**June 1 (Monday) — Completed**
**zhanlan:** Generated all 15 character concept images (Nano Banana + Meshy AI), completed all 3D models and rigging in Meshy AI, validated Unity import workflow
**lisa:** Furniture placement completed for RoomA1, RoomA2, RoomB1, RoomB3 (ahead of schedule), completed moodboard, color palette, and UX flow documentation

**June 2 (Tuesday) — Completed**
**zhanlan:** Batch imported all 15 character models into Unity with Humanoid Rig configured. Completed motion capture recordings for RoomA1, A2, B1, B2, C2, and C3, covering 23 animation states.
**lisa:** Participated in RoomC3 motion capture recording. Imported models and placed furniture for RoomB1, RoomB3, RoomC3. Updated window models across the building facade.

**June 3 (Wednesday) — Completed**
**zhanlan:** Trimmed, renamed, and organized all animations into Unity folders. Completed RoomC2 dancer pipeline (animation binding, materials, duplication to nine dancers). Finalized interaction system architecture (GameManager, CameraController, ClickDetector, per-room Interactables).
**lisa:** Placed furniture for RoomA3 and RoomC2. Built the opposing building view (opening scene apartment).

**June 4 (Thursday) — Completed**
**zhanlan:** Completed RoomA2 (WorkMan) interaction end to end, establishing the reusable "random idle + click-triggered one-shot" pattern (AnyState + bool). Documented a full set of Animator and coroutine pitfalls (Can Transition To Self, Loop Time vs normalizedTime, redundant conditions, bool clearing timing, the click trio).

**June 5 (Friday) — Completed**
**zhanlan:** Completed RoomB1 (Boy, sequence: Up → random WaveHand → Down), RoomB2 (OldWoman, sequence: PickUp → Calling → PutDown), and RoomA1 (ToiletMan, click → scream + window close via Animation Event). Validated a second reusable pattern for sequence-type rooms (direct state-to-state transitions chained by Has Exit Time). Began migrating finished rooms from GreyBoxing to FinalYellowBuilding.


---

**Status Summary (as of June 5)**

- Rooms complete (4/7): A1, A2, B1, B2 — animation and click interaction working in GreyBoxing
- Rooms remaining (3/7): A3 (the cat, most complex, behaves differently across both modes), C3 + C2 (cross-room linkage)
- Core trio (GameManager, CameraController, ClickDetector): not yet written; each room's ReportCompletion is a placeholder
- Open issue: after migration to Final, idle plays but clicking fails (ray not reaching characters). Suspected Input System module or Physics Raycaster Event Mask. Deferred until Lisa's scene exists, since characters will be repositioned
- Schedule risk: lisa's scene assembly and gold's audio/text are both behind the v4 plan; neither has logged progress yet

---

**June 6 (Saturday)**
**zhanlan:** Build remaining rooms A3 (cat) and C3 + C2 linkage. Replace A1 script with single-direction locked version
**lisa:** Begin scene assembly, building materials (catch up from v4)
**gold:** Select all sound effect materials (toilet flush, cat sounds, laughter, dance music); begin text assets

**June 7 (Sunday)**
**zhanlan:** Write Core trio (GameManager, CameraController, ClickDetector). Define Interactable interface with unified OnInteract() entry. Wire each room's ReportCompletion into GameManager
**gold:** AngerWords x3, Complain x3, TalkOnPhone subtitles; podcast and remaining audio editing, deliver files to zhanlan

**June 8 (Monday)**
**zhanlan:** Full interaction system integration in Final. Resolve the post-migration click issue. Import real audio to replace placeholders, begin bug fixing
**lisa:** Import all assets into scene, begin lighting
**gold:** Begin PDF production, continue any remaining audio/text delivery

**June 9 (Tuesday)**
**zhanlan + lisa:** Full scene integration, run through all interactions in both modes, record bug list
**gold:** Continue PDF production

**June 10 (Wednesday)**
**zhanlan + lisa:** Bug fixing round one
**gold:** PDF final touches

**June 11 (Thursday)**
**zhanlan + lisa:** Bug fixing round two

**June 12 (Friday)**
**zhanlan:** Final testing, prepare demo version

**June 13 (Saturday)**
**zhanlan:** Buffer, polish

**June 14 (Sunday)**
Buffer day
**gold:** Deliver presentation PDF

**June 15 (Monday)**
Presentation run-through, PDF deadline 12:00

**June 16 (Tuesday)**
Final Presentation

---

**Key Changes from v4**

- Four rooms (A1, A2, B1, B2) completed on schedule across June 4–5; two reusable interaction patterns validated and documented for the remaining rooms
- Two rooms slipped to June 6: A3 (cat) and C3/C2 were planned for June 4–5 but deprioritized behind the four simpler rooms
- Core trio moved from June 6 to June 7, following the remaining rooms
- New open issue tracked: post-migration click failure in the Final project, to be resolved during June 8 integration once Lisa's scene exists
- Schedule risk flagged: lisa (scene assembly) and gold (audio/text) have not logged progress against v4; both carry catch-up work starting June 6. Gold's start appears to have slipped from the planned June 4
- Buffer from June 12–14 still intact, but tighter given the room and Core work now compressed into June 6–7