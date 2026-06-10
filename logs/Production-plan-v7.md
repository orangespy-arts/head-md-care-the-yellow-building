

**The Yellow Building — Production Plan v7**
*Updated: June 10, 2026*

---

**Team & Responsibilities**

**zhanlan**
Character model generation, rigging, animation sourcing and binding, interaction scripts, text assets (AngerWords, Complain, TalkOnPhone subtitles)

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

---

**Status Summary (as of June 10)**

Rooms complete (9/9): A1, A2, A3 (cat screensaver), B1, B2, B3, C1, C2, C3 — all interactions working in GreyBoxing

Scene assembly: all nine rooms complete (lisa); exterior planters and building textures complete (lisa)

Core system: complete in GreyBoxing — two-mode architecture (Default / Screensaver), IRoomResettable reset on exit, Pointer-based input working on laptop trackpad, camera push-in and symmetric smooth zoom-out

Open issues: post-migration click issue in Final project unresolved; Toon Shader not yet configured (dancer disappearance currently SetActive, fade-out deferred); text assets (AngerWords, Complain, TalkOnPhone) not yet written; audio not yet imported; lighting not yet started

---

**June 11 (Thursday)**
**zhanlan:** Write text assets (AngerWords x3, Complain x3, TalkOnPhone subtitles). Begin full interaction integration in Final project; tackle the post-migration click issue
**lisa:** Begin importing audio assets, begin lighting

**June 12 (Friday)**
**zhanlan + lisa:** Full scene integration in Final. Run through all interactions in both modes (and screensaver). Record bug list. Resolve post-migration click issue

**June 13 (Saturday)**
**zhanlan + lisa:** Bug fixing round one. Configure Toon Shader, switch dancer disappearance to fade-out

**June 14 (Sunday)**
**zhanlan + lisa:** Bug fixing round two. Buffer

**June 15 (Monday)**
Presentation run-through. PDF deadline 12:00 *(owner TBD)*

**June 16 (Tuesday)**
Final Presentation

---

**Key Changes from v6**

- Core system completed on schedule (June 10): full two-mode Default / Screensaver architecture written and working in GreyBoxing, ahead of the v6 estimate that deferred completion to June 11
- A3 cat fully resolved: position/orientation bug fixed, jump displacement and landing done, integrated as the screensaver driver — cat screensaver mode now working
- Two screensaver input bugs found and fixed, both rooted in laptop trackpad tap-to-click not registering on the Mouse channel in the new Input System; resolved by switching to Pointer.current.press
- Screensaver exit upgraded to a smooth symmetric zoom-out (was a one-frame snap)
- lisa pivoted June 10 to exterior planters and building textures (audio/lighting from the v6 plan pushed to June 11)
- All nine rooms now complete and interactive in GreyBoxing (9/9), including B3 and C1
- Text assets, Final integration, audio, lighting, and Toon Shader all remain compressed into June 11–14; schedule still tight
- PDF owner still undecided; deadline remains June 15 at 12:00
