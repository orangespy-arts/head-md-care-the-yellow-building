**Work Log — June 10, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Completed the cat system: fixed the Humanoid rig / Generic clip conflict (both fbx set to Humanoid), fixed the facing bug using a facingTarget empty as the orientation reference, implemented parabolic jump displacement (adjustable arcHeight), and added the Land_stop-edit landing animation. Wrote the Core systems — GameManager (Default / Screensaver two-mode architecture, IRoomResettable interface, new Input System) and CameraController (screensaver push-in + cat follow). Batch-updated the five room scripts (BoyAnimControl, OldWoman, TalkComplain, ToiletMan, WorkManControl) to implement IRoomResettable, add interaction blocking via GameManager.InteractionEnabled, and add per-room ResetRoom(). Fixed two screensaver bugs (see Design Decisions / Bug Fixes).

**lisa**

- Modeled all the planters/potted plants around the exterior of the building
- Authored the textures for the building itself

---

**Bug Fixes / Design Decisions**

- **Screensaver exit was failing** on the laptop. Root cause: trackpad tap-to-click does not register on `Mouse.leftButton` in the new Input System (it routes through the Touchscreen/Pen channel), so `Mouse.current.leftButton.wasPressedThisFrame` was always false. Fix: detect via `Pointer.current.press`, the common base of Mouse/Pen/Touchscreen, which covers all click-like input in one line.
- **Screensaver exit now zooms out smoothly** instead of snapping back. CameraController now lerps toward the target position in both modes (target = defaultPosition on exit), making enter and exit symmetric. Exit speed equals enter speed (both use followSpeed).
- **Screensaver no longer triggers during interaction.** Same root cause as the exit bug — the Default-mode idle detection also used the Mouse-only channel, so trackpad taps did not reset the idle timer and the screensaver would cut in mid-interaction. Fix: Default-mode activity detection also uses `Pointer.current.press`, so any click (mouse / trackpad tap / touch / pen) resets the idle timer. Now it is a true screensaver — only genuine idle for idleThreshold seconds triggers it.
- Removed the now-redundant manually-created `clickAction` InputAction; both Default and Screensaver branches share the same `Pointer` check.

---

**Pending — June 11**

- Text assets: AngerWords x3, Complain x3, TalkOnPhone subtitles
- Final project integration: click-failure issue after migration
- Toon Shader config: change dancer disappearance to a fade-out
