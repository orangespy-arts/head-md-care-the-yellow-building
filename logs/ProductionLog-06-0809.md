**Work Log — June 8–9, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Completed the C3 Couple room interaction over these two days, including the C2 dancer-reduction linkage, and made substantial progress on the A3 cat, which has been redesigned from an interactive object into a screensaver-mode trigger.

RoomC3 (Couple): two separate characters, CoupleLeft (Couple1) and CoupleRight (Couple2), each driven by its own Animator Controller. The animation was a single synchronized recording cut into independent clips, so rather than forcing two Animators to stay frame-locked, the two controllers share an identical structure and the script triggers both on the same frame, letting the matched clip lengths keep them in sync. Originally each idle was three alternating Talk clips (Talk1 / Talk2 / Talk3); these were simplified down to a single looping Talk1 state to keep the Animator clean, at the cost of visible repetition, which is acceptable. Two clicks complete the room: the first plays Wait / Complain, the second plays Complain / Wait, then locks. Order protection lives entirely in the script via clickCount rather than in the Animator.

C2 dancer-reduction linkage: the dancePeoples group holds nine dancers. Each couple complaint removes four (batch1 = dancers 1–4, batch2 = dancers 5–8), leaving the ninth standing alone at the end. Implemented as public GameObject arrays assigned by drag-and-drop in the Inspector rather than GameObject.Find, with dancers disappearing one-by-one (SetActive false for now; fade-out deferred until the Toon Shader is configured). Two public parameters expose the timing: disappearInterval for the gap between each dancer vanishing, and disappearAt, a 0–1 slider controlling at what point in the complaint animation the disappearances begin.

RoomA3 (Cat): redesigned mid-session. The cat is no longer a per-mode interactive object but a screensaver trigger: after a period of no input the cat jumps between balconies and the camera pushes in (smaller FOV) to reveal room detail, with any click exiting back to normal mode. The screensaver enter/exit and camera logic are not yet built; this session focused on the cat's jump loop. The cat lives on a 3x3 grid where row number equals height level. Legal jumps are left/right flat, and left/right diagonal up or down (up to six neighbors); straight vertical moves within the same column (e.g. B1 to B2) and height differences greater than one level are both disallowed. Start position is fixed at A3. For now a single pair of states (Pet_sit idle and JumpCurve, the Run clip trimmed to keep only the jump arc) covers all jumps, to be refined by direction later. The cat's jump loop runs automatically with the script calling SetTrigger on its own timer, since a screensaver needs no player input.

---

**lisa**

Created the C3 banner model and completed the asset placement and scene assembly for the B2 and C3 rooms.

---

**Design Decisions**

- C3 couple synchronization solved by shared controller structure plus same-frame triggering, not frame-locking. The two characters' clips came from one synchronized recording, so matched clip lengths preserve sync as long as both Animators are triggered on the same frame. This is simpler and more robust than trying to keep two independent Animators aligned
- IsName state-name checks abandoned for detecting animation completion. The check returned false even with the "Base Layer." prefix; replaced with an IsInTransition enter/exit check followed by waiting out the clip length. This is the new go-to pattern for "wait until animation finishes" and supersedes the normalizedTime approach where Loop Time is on
- Animator Parameter names must be verified against the script string. The parameters were Trigger1 / Trigger2, not the Click1 / Click2 the script assumed, which silently produced "parameter does not exist" warnings
- C2 reduction uses Inspector-assigned public arrays, not GameObject.Find. More direct, name-independent, and visible at a glance which dancers belong to which batch
- Disappearance timing exposed as public parameters (disappearInterval, disappearAt) so the moment and pacing can be tuned live without code changes
- A3 cat redesigned from interactive object to screensaver trigger. This changes the cat's role in the overall interaction model and should be reconciled with ARCHITECTURE later
- Cat jump rules encoded as a coords array with an IsValidJump check (column must change, row difference at most one), keeping the legal-neighbor logic in one place
- Cat animation deliberately under-specified for now: one idle plus one jump-arc clip covers every direction, with directional refinement (Fall_low for diagonal-down, etc.) deferred until the basic loop works

---

**Pending — June 10**

- Fix the cat's position and orientation after teleporting to a balcony (currently lying down and clipping into geometry). Root cause still to be confirmed: the CatBalcony marker points' own position and rotation may not be set correctly. Note that the Start method force-sets position, which overrides any manually placed starting position, and rotation inherited from the balcony makes the cat lie down; next session, test orientation with Quaternion.identity first, then verify each CatBalcony marker point individually
- Build the cat screensaver mode: enter/exit logic and the camera FOV push-in
- Configure the Toon Shader and switch dancer disappearance from SetActive to a fade-out
- The Core trio (GameManager, CameraController, ClickDetector) remains unwritten; each room's ReportCompletion is still a placeholder
- Reconcile ARCHITECTURE with what was actually built: the C3 Talk simplification, the C2 reduction implementation, and the A3 cat redesign from interactive object to screensaver