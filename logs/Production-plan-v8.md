

**The Yellow Building — Production Plan v8**
*Updated: June 12, 2026*

---

**Team & Responsibilities**

**zhanlan**
Character model generation, rigging, animation sourcing and binding, interaction scripts, text assets (AngerWords, Complain, TalkOnPhone subtitles), four-state game architecture, dissolve and ending systems

**lisa**
Furniture asset collection, scene assembly, building materials/textures, exterior props, lighting, sound effect import and room mounting

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

**June 10** — zhanlan: completed the cat system (fixed Humanoid rig / Generic clip conflict, fixed orientation via facingTarget, parabolic jump displacement, landing animation). Wrote the Core systems — GameManager (Default / Screensaver two-mode architecture, IRoomResettable interface, new Input System) and CameraController (screensaver push-in + cat follow, smooth zoom-out on exit). Batch-updated all five room scripts to implement IRoomResettable, interaction blocking, and ResetRoom(). Fixed two screensaver bugs (laptop trackpad tap not registering on Mouse channel — switched detection to Pointer.current.press for both enter idle-reset and exit). lisa: modeled all exterior planters/potted plants around the building, authored the building textures.

**June 11** — zhanlan: built the FloatingText system — a world-space TextMeshPro label per room with ShowLine / ShowSequence / Hide API and fade in/out; multiple rooms can run simultaneously on independent coroutines; dialogue exposed as [TextArea] string[] for French copy entry without code changes; wired into WorkMan (A2), Couple (C3), and OldWoman (B2). Expanded the two-state architecture to a full four-state cycle (Screensaver → Interactive → Dissolving → Ending → back to Screensaver): added GameState enum, RegisterInteractive / ReportCompletion API, idle timeout (45 s), and completion tracking for all five interactive rooms with deduplication. Built the State3 dissolve system: GameManager `rooms[9]` (`GameObject[]`) array where each slot holds an empty parent, direct children fade out sequentially on `objectInterval` with rooms staggered by `roomDissolveInterval`; initial active-state memory prevents props that started disabled from being wrongly re-enabled on reset; Cat.cs gained Hide() / ResetCat(). Built the State4 ending: ending room placed with `endingView` camera anchor and `endingCatPerch` windowsill position; CameraController lerps both position and rotation to the ending shot; Cat.cs gained AppearAt(perch); fade-to-black dims sunLight and fades a full-screen CanvasGroup (no jump on reset); ResetAll restores lighting before returning to State1. Fixed frame rate regression caused by com.unity.ai.assistant pre-release package network-authorization loop (package removed). Restored cat animation to the June 10 state (commit 636e32d). Verified complete four-state loop across three consecutive runs with no anomalies. lisa: edited and trimmed all audio assets; made visual adjustments to the scene.

---

**Status Summary (as of June 11)**

Four-state cycle complete: Screensaver → Interactive → Dissolving → Ending → Screensaver runs end to end in the Final project, verified over three consecutive loops.

Rooms complete (9/9): all interactions working; five rooms registered with completion reporting (A1 click / A2 Angry / B1 head-up / B2 phone / C3 two-click), deduplication in place.

FloatingText system complete: world-space labels on A2, B2, C3; French copy slots ready in Inspector.

Scene assembly: all nine rooms complete; exterior planters and building textures complete; ending room placed with camera and cat anchors.

Open issues: post-migration click issue in Final project unresolved; Toon Shader not yet configured (dancer disappearance currently SetActive, fade-out deferred); French text copy not yet written; audio not yet imported; debug skip screensaver flag must be turned off before exhibition and idle threshold returned to 45 s.

---

**June 12 (Friday)**
**zhanlan:** Write final French copy for FloatingText (AngerWords x3, Complain x3, TalkOnPhone subtitles). Resolve post-migration click issue (EventSystem InputSystemUIInputModule, Physics Raycaster, Collider check). Begin Toon Shader configuration.
**lisa:** Begin audio import and room mounting. Begin lighting.

**June 13 (Saturday)**
**zhanlan + lisa:** Toon Shader — switch dancer disappearance from SetActive to material fade-out. Audio integration. Full four-state loop verification with audio and final French copy in place.

**June 14 (Sunday)**
**zhanlan + lisa:** Parameter finalization (allCompleteDelay, dissolve rhythm, fade-to-black duration). Turn off debugSkipScreensaver, confirm idle threshold 45 s. Buffer for remaining bugs.

**June 15 (Monday)**
Windows Build full-screen test (not editor only). On-site device test (trackpad / touch screen click). Auto-launch on boot. Stress test: unattended loop 30 minutes, confirm no accumulated errors or memory growth. PDF deadline 12:00 *(owner TBD)*

**June 16 (Tuesday)**
Final Presentation

---

**Key Changes from v7**

- Four-state architecture complete (June 11, well ahead of v7 schedule): Screensaver → Interactive → Dissolving → Ending loop runs end to end and verified over three consecutive cycles
- FloatingText system added (June 11): world-space TMP labels with ShowLine / ShowSequence / Hide and coroutine-safe multi-room simultaneous display; language confirmed as French
- State3 dissolve system built and working: rooms[9] empty-parent design, sequential child fade, overlapping room timing, initial active-state memory
- State4 ending built and working: ending room, dual-lerp camera, Cat.AppearAt, CanvasGroup fade-to-black, full reset to State1
- Frame rate regression fixed (June 11): com.unity.ai.assistant pre-release package removed
- DavinRoom-clean.unitypackage imported and validated (lisa, June 11)
- Schedule substantially compressed: v7 allocated June 11–13 to core architecture; all four stages are now done with June 11 to spare, freeing June 12–14 entirely for content, audio, and Toon Shader
- Post-migration click issue, Toon Shader fade-out, French copy, and audio remain open; all targeted for June 12–13
- PDF owner still undecided; deadline remains June 15 at 12:00
