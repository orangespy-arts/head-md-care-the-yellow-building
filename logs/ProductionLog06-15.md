**Work Log — June 15, 2026**
**Project: The Yellow Building**

---

**zhanlan**

**Room audio integration.** Brought Lisa's two source tracks (`radio-station`, `podcast`) into the project. They were MP3 streams wrapped in an `.mpeg` container, which Unity routed to its *video* importer and rejected ("no video tracks"). Remuxed them losslessly to proper `.mp3` AudioClips under `Assets/Audio/` so Unity imports them as audio.

**OldWoman (B2) — click-to-toggle podcast.** Reworked the room into a play/pause podcast player. First click: she picks up the phone and the podcast plays from the start; click again: she **puts the phone down** and the audio pauses in place; click again: she picks the phone back up and the audio **resumes from where it left off**. When the podcast finishes she hangs up on her own and the room reports complete. Driven by a single `Talking` bool into a looping `03-Calling` state; the clip is now a draggable `AudioClip` field (AudioSource auto-created).

**A3 RadioStation — new room.** Added a light-bulb + radio interaction. Click turns the bulb on and plays the station (looping); click again switches the bulb off and pauses; next click resumes from position. Bulb glow via a Light plus an emissive-material toggle (`Bulb Renderer` + HDR `Emission Color`). Click target sits on the window, not the bulb.

**Audio exclusivity.** Added a small coordinator (`AudioExclusivity` / `IExclusiveAudio`) so only one audio plays at a time: starting the radio puts the old woman's phone down and pauses her podcast, and vice-versa — each resumes from its own paused position when re-selected.

**Ending sequence (State4).** Built out the ending controls on GameManager / CameraController:
- Cat now lands on a **table in the other room** (`endingCatTable`) with its own placement offset (`endingCatOffset`).
- Camera zoom-out is now a **precise eased duration** (`endingZoomDuration`) with a tunable ending height (`endingHeightOffset`).
- "Yellow building goes dark, bedroom stays lit": after trying sun/ambient fade and a full-screen black canvas, settled on a **3D black plane** placed outside the window that fades in (`blackoutQuad` + `endingBlackoutAlpha`) — transparent the whole time, only fading to black after the zoom-out. Perspective-correct and resolution-independent.
- `debugSkipToEnding` switch to jump straight to the ending for tuning.

**Idle behaviour split (by engagement).** Separated the two idle outcomes. A visitor who never touches anything returns to the **screensaver** after a short idle (`idleToScreensaverThreshold`, 20s); a visitor who has interacted gets the **full ending** after a longer idle (`idleDissolveThreshold`, 45s). Engagement is "clicked at least once," so passers-by don't trigger the ending and a listener standing through the long podcast isn't cut off.

**Cat.** Fixed the cat spawning mid-air at startup (root motion writing into the transform + reading sill anchors one frame early) — pinned with `applyRootMotion` off plus a position offset. Added **two speed profiles**: a calmer screensaver pace and a livelier interactive pace (stay-time range + jump duration). Screensaver camera now follows the cat with an adjustable height offset (`screensaverFollowYOffset`).

**Interaction targets moved to windows (iPad).** To make rooms reliably tappable on the venue iPad, moved every room's click target from the small character collider onto the large **window**. Each room script now lives on its window with the character's Animator wired in as a reference (C3 needed no code change since its Animators were already public). Added a small `ToiletManAnimRelay` on the character so the `CloseWindow` animation event still reaches the relocated ToiletMan script.

---

**lisa**

Produced the presentation PDF (exhibition / room-guide handout). Audio assets (podcast, radio-station) from the edited set integrated into B2 and A3.

---

**Bug Fixes / Design Decisions**

- **FloatingText / in-game text — cancelled.** The speaking rooms play animation + audio only; no on-screen subtitles. (Earlier work log described it as built; it is intentionally not in the project.)
- **OldWoman pause semantics** — chose "put the phone down on pause" (re-pick-up on resume) over freezing the animation in place.
- **Ending blackout** — chose a 3D occluder plane over a screen-space black canvas, so it tracks perspective and doesn't depend on screen resolution/aspect (the canvas needed per-resolution alignment to cover only the window).
- **Idle engagement signal** — used "clicked at least once" rather than "completed a room," so the multi-minute podcast isn't interrupted by the short screensaver timeout.

---

**Pending — June 16**

- Finish moving A2 / B1 / B2 / C3 scripts onto their windows + re-wire references; verify each is clickable on the iPad.
- Tune the ending: blackout-plane placement/size, cat-on-table offset, camera zoom height/duration, final darkness.
- Mount remaining SFX (ToiletMan flush, C2 music fading with the couple's complaints).
- Davin feedback still open: legibility / entry cue, cat-click → jump, reduce cat idle motion if still distracting.
- Before exhibition: turn off both debug switches (`Debug Skip Screensaver`, `Debug Skip To Ending`), set idle thresholds to show values, Windows build fullscreen + stress test.
