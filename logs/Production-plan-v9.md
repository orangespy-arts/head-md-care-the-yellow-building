**The Yellow Building — Production Plan v9**
*Updated: June 12, 2026*

---

**Team & Responsibilities**

**zhanlan**
Character model generation, rigging, animation sourcing and binding, interaction scripts, text assets (AngerWords, Complain, TalkOnPhone subtitles), four-state game architecture, dissolve and ending systems

**lisa**
Furniture asset collection, scene assembly, building materials/textures, exterior props, lighting, sound effect import and room mounting, toon shaders

**gold** *(no longer available)*
Tasks redistributed to zhanlan and lisa as above

---

**Completed**

**June 1** 
zhanlan: all 15 character models generated, rigged, and validated. 
lisa: furniture placement for A1, A2, B1, B3, moodboard, color palette, UX flow documentation.

**June 2**  
Zhanlan: all 15 models imported with Humanoid Rig, motion capture for A1, A2, B1, B2, C2, C3 (23 states). 
Lisa: participated in C3 mocap, imported models, placed furniture for B1, B3, C3, updated window models.

**June 3** 
zhanlan: trimmed and organized all animations, completed C2 dancer pipeline (binding, materials, duplication to nine dancers), finalized interaction system architecture. 
lisa: furniture placement for A3 and C2, built opposing building view.

**June 4** 
zhanlan: completed RoomA2 (WorkMan) interaction end to end, established reusable Pattern A (random idle + click-triggered one-shot), documented Animator and coroutine pitfalls.

**June 5** 
zhanlan: completed RoomB1 (Boy), RoomB2 (OldWoman), RoomA1 (ToiletMan), established reusable Pattern B (sequence rooms via Has Exit Time). Began migration from GreyBoxing to Final; click issue after migration deferred.

**June 8–9** 
zhanlan: completed RoomC3 couple interaction (two-click sequence, synchronized dual Animator, AnyState structure), completed C2 dancer-reduction linkage (batch disappearance with public timing parameters). Began A3 cat screensaver mode: jump loop logic written, position/orientation bug pending. lisa: completed scene assembly for all nine rooms, created C3 banner model.

**June 10** 
zhanlan: completed the cat system (fixed Humanoid rig / Generic clip conflict, fixed orientation via facingTarget, parabolic jump displacement, landing animation). Wrote the Core systems — GameManager (Default / Screensaver two-mode architecture, IRoomResettable interface, new Input System) and CameraController (screensaver push-in + cat follow, smooth zoom-out on exit). Batch-updated all five room scripts to implement IRoomResettable, interaction blocking, and ResetRoom(). Fixed two screensaver bugs (laptop trackpad tap not registering on Mouse channel — switched detection to Pointer.current.press for both enter idle-reset and exit). 
lisa: modeled all exterior planters/potted plants around the building, authored the building textures.

**June 11** 
zhanlan: built the FloatingText system — a world-space TextMeshPro label per room with ShowLine / ShowSequence / Hide API and fade in/out; multiple rooms can run simultaneously on independent coroutines; dialogue exposed as [TextArea] string[] for French copy entry without code changes; wired into WorkMan (A2), Couple (C3), and OldWoman (B2). Expanded the two-state architecture to a full four-state cycle (Screensaver → Interactive → Dissolving → Ending → back to Screensaver): added GameState enum, RegisterInteractive / ReportCompletion API, idle timeout (45 s), and completion tracking for all five interactive rooms with deduplication. Built the State3 dissolve system: GameManager `rooms[9]` (`GameObject[]`) array where each slot holds an empty parent, direct children fade out sequentially on `objectInterval` with rooms staggered by `roomDissolveInterval`; initial active-state memory prevents props that started disabled from being wrongly re-enabled on reset; Cat.cs gained Hide() / ResetCat(). Built the State4 ending: ending room placed with `endingView` camera anchor and `endingCatPerch` windowsill position; CameraController lerps both position and rotation to the ending shot; Cat.cs gained AppearAt(perch); fade-to-black dims sunLight and fades a full-screen CanvasGroup (no jump on reset); ResetAll restores lighting before returning to State1. Fixed frame rate regression caused by com.unity.ai.assistant pre-release package network-authorization loop (package removed). Restored cat animation to the June 10 state (commit 636e32d). Verified complete four-state loop across three consecutive runs with no anomalies. 
lisa: edited and trimmed all audio assets; made visual adjustments to the scene.

**June 12** zhanlan: migrated all animations from greybox scene into the final project; all room characters now animate correctly in the production scene. Fixed miscellaneous bugs uncovered during migration. Davin room-light review session held — feedback recorded (see below). 
lisa: implemented toon shaders; materials updated across affected objects.

---

**Another room Review Feedback (June 12)**

- **Legibility** — visitors don't know what to do on room entry; need a clearer affordance or entry cue
- **Cat movement** — cat idle motion is too frequent/large and distracts from room content
- **Cat interaction** — clicking the cat should trigger a jump; currently not obvious or not wired
- **Hit areas** — several clickable objects have colliders too small to hit reliably; enlarge
- **PDF** — exhibition handout / guide must be exported before June 15

---

**Status Summary (as of June 12)**

Four-state cycle complete and running in the Final project. All animations migrated from greybox. Toon shaders implemented by lisa. Key content gaps remaining: character positions need adjustment post-migration, camera-to-cat shot not yet wired, music and sound not yet mounted, room-disappear sequence at end needs verification. UX issues from Davin review to address before exhibition. French copy not yet written. PDF not yet exported.

---

**June 13 (Saturday)**
**zhanlan:** Fix character positions (post-migration offsets). Wire camera-follow-cat transition. Write final French copy for FloatingText (AngerWords ×3, Complain ×3, TalkOnPhone subtitles). Address Davin feedback: add room-entry affordance cues, reduce cat idle motion, wire cat-click → jump, enlarge small interaction colliders.
**lisa:** Mount all music and sound effects to rooms (OldWoman podcast 1–3, ToiletMan flush, C2 music fade, remaining SFX). Verify room-disappear sequence at end of State3/State4.

**June 14 (Sunday)**
**zhanlan + lisa:** Full four-state loop verification with audio, French copy, and toon shaders in place. Parameter finalization (allCompleteDelay, dissolve rhythm, fade-to-black duration). Turn off debugSkipScreensaver; confirm idle threshold 45 s. Buffer for remaining bugs.

**June 15 (Monday)**
Windows build full-screen test (not editor only). On-site device test (trackpad / touch screen click). Auto-launch on boot. Stress test: unattended loop 30 minutes, confirm no accumulated errors or memory growth. **PDF export deadline 12:00** *(owner TBD)*

**June 16 (Tuesday)**
Final Presentation

**June 17 (Wednesday)**
Documentation Day
zhanlan: organize Github
liza: video edit, finish pdf
---

**Key Changes from v8**

- June 12 greybox → final animation migration complete (zhanlan); all room characters animate in production scene
- Toon shaders implemented (lisa, June 12); dancer disappearance method to be verified (SetActive → fade-out)
- Davin review session held June 12; four UX issues logged: legibility on room entry, cat idle over-movement, cat-click jump not wired, interaction colliders too small
- Character positions need fixing post-migration (new open issue)
- Camera-follow-cat shot still pending (carried from v8)
- Audio mounting still pending (carried from v8); French copy still pending (carried from v8)
- Room-disappear sequence at end needs verification after migration
- June 13 plan updated to consolidate all remaining content and UX feedback tasks
- PDF owner still undecided; deadline remains June 15 at 12:00
