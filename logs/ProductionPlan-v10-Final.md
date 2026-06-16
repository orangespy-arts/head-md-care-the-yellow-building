**The Yellow Building — Production Plan v10 (Final)**
*Updated: June 16, 2026*

---

**Team & Responsibilities**

**zhanlan**
Character model generation, rigging, animation sourcing and binding, interaction scripts, four-state game architecture, dissolve and ending systems, room audio integration and audio exclusivity, iPad interaction (window hit-targets)

**lisa**
Furniture asset collection, scene assembly, building materials/textures, exterior props, lighting, sound effect import and room mounting, toon shaders, presentation PDF

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

**June 11** — zhanlan: built the FloatingText system (later cancelled — see June 15). Expanded the two-state architecture to a full four-state cycle (Screensaver → Interactive → Dissolving → Ending → back to Screensaver): added GameState enum, RegisterInteractive / ReportCompletion API, idle timeout, and completion tracking for all five interactive rooms with deduplication. Built the State3 dissolve system: GameManager `rooms[9]` (`GameObject[]`) array where each slot holds an empty parent, direct children fade out sequentially on `objectInterval` with rooms staggered by `roomDissolveInterval`; initial active-state memory prevents props that started disabled from being wrongly re-enabled on reset; Cat.cs gained Hide() / ResetCat(). Built the State4 ending: ending room placed with camera anchor and `endingCatPerch`; CameraController lerps position and rotation to the ending shot; Cat.cs gained AppearAt(perch); ResetAll restores state before returning to State1. Fixed frame rate regression caused by com.unity.ai.assistant pre-release package (package removed). Verified the four-state loop across three consecutive runs. lisa: edited and trimmed all audio assets; made visual adjustments to the scene.

**June 12** — zhanlan: migrated all animations from greybox scene into the final project; all room characters now animate correctly in the production scene. Fixed miscellaneous bugs uncovered during migration. Davin room-light review session held — feedback recorded (see below). lisa: implemented toon shaders; materials updated across affected objects.

**June 13 (Saturday) & June 14 (Sunday)** — Weekend, no work.

**June 15 (Monday)** — zhanlan: Integrated the room audio — remuxed Lisa's `radio-station` and `podcast` tracks (MP3 inside an `.mpeg` container, which Unity's video importer rejected) losslessly to `.mp3` under `Assets/Audio/`. Reworked **OldWoman (B2)** into a click-to-toggle podcast: pick up phone + play → put phone down + pause → pick up + resume from position; hangs up and reports complete when the podcast finishes (single `Talking` bool into a looping Calling state; clip is a draggable AudioClip). Added a new **A3 RadioStation** room — light-bulb + radio toggle with play/pause-from-position, looping playback, and bulb emission glow; click target on the window. Added an **audio-exclusivity** coordinator so only one audio plays at a time (starting the radio pauses the podcast and vice-versa, each resuming from its own position). Built out the **State4 ending**: cat lands on a table in the other room (`endingCatTable` + offset); precise eased camera zoom-out (`endingZoomDuration`) with tunable height (`endingHeightOffset`); "yellow building goes dark, bedroom stays lit" achieved with a perspective-correct **3D black plane** outside the window (`blackoutQuad` + `endingBlackoutAlpha`, transparent until after zoom-out); `debugSkipToEnding` switch for tuning. Split idle handling by **engagement**: never-touched → screensaver after a short idle (`idleToScreensaverThreshold`, 20 s); interacted → full ending after a longer idle (`idleDissolveThreshold`, 45 s). Fixed the cat spawning mid-air at startup (root motion + early anchor read) and added two cat **speed profiles** (calm screensaver / lively interactive) plus an adjustable screensaver camera follow height. Moved every room's **click target onto the large window** for reliable iPad tapping — room scripts relocated to their windows with the character Animator wired as a reference (C3 needed no code change), plus a `ToiletManAnimRelay` so the CloseWindow animation event still reaches the relocated ToiletMan. Confirmed the **FloatingText system is cancelled** — the speaking rooms play animation + audio only, no on-screen subtitles. lisa: produced the presentation PDF; provided and integrated the edited audio assets (podcast, radio-station).

**June 16 (Tuesday)** — Final presentation delivered. Project complete.

---

**Davin Review Feedback (June 12) — final status**

- **Legibility** — room-entry affordance cue: *still open* (not implemented)
- **Cat movement** — *addressed*: two cat speed profiles added, screensaver idle pace can be dialed down
- **Cat interaction** — click-cat → jump: *still open*
- **Hit areas** — *addressed*: all room click targets moved onto the large windows for reliable iPad tapping
- **PDF** — *done* (lisa, June 15)

---

**Status Summary (as of June 16)**

Four-state cycle complete and running in the Final project; presented June 16. All animations migrated from greybox; toon shaders in place (lisa). Room audio integrated and mounted (OldWoman podcast, A3 radio) with single-audio exclusivity; ending sequence finished (cat-on-table, eased zoom-out, 3D blackout darkening the yellow building while the bedroom stays lit). Idle behaviour split by engagement (screensaver vs. ending). iPad reliability addressed by moving all interaction colliders onto the windows. FloatingText / French subtitles cancelled. Presentation PDF delivered. Remaining nice-to-haves not done: room-entry legibility cue and cat-click → jump (Davin feedback, deferred).

---

**Key Changes from v9**

- June 13–14 were a weekend — **no work** (v9 had tentatively planned tasks here; none were carried out on those days)
- All remaining content consolidated into **June 15**: audio integration, OldWoman podcast play/pause, new A3 RadioStation, audio exclusivity, ending system (cat-on-table, eased zoom, 3D blackout), idle-by-engagement split, cat fixes + speed profiles, and the move of all interaction colliders onto the windows for iPad
- **FloatingText cancelled** (and with it the French copy task from v9) — speaking rooms are animation + audio only
- **Ending blackout** changed from a full-screen CanvasGroup to a **3D occluder plane** (perspective-correct, resolution-independent)
- **Hit-area** Davin feedback resolved by relocating click targets to windows; **cat over-movement** addressed via speed profiles
- Presentation **PDF delivered** by lisa (June 15)
- **June 16: final presentation completed** — project shipped
