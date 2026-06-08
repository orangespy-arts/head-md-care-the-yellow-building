**Work Log — June 4–5, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Completed interaction scripting and animation for four rooms over these two days (A1, A2, B1, B2), and validated two reusable interaction patterns that the remaining rooms can map onto.

RoomA2 (WorkMan): the character loops randomly through three idle poses (UseComputer / Sit / Think) when untouched, and a click triggers the Angery animation, which plays once before returning to the idle loop. One click to complete. This room established the "random idle + click-triggered one-shot" pattern: idle switching is driven by script (the Animator does not handle randomness), while the one-shot action runs through an AnyState transition gated by a bool, keeping the two decoupled. Worked through and documented a full set of Animator and coroutine pitfalls in the process: the click trio (Collider, Physics Raycaster, EventSystem) all being required; AnyState transitions self-interrupting when Can Transition To Self is left on; Loop Time breaking every normalizedTime check; reading clip length mid-transition returning the wrong value; a redundant transition condition silently blocking the trigger; and the bool needing to clear at the right moment to avoid looping between idle and the action.

RoomB1 (Boy): idle by default, with a click triggering a fixed sequence of Up → a randomly chosen WaveHand (three options) → Down → back to idle. One click to complete. Validated a second reusable pattern for sequence-type rooms using direct state-to-state transitions chained by Has Exit Time, with the script only starting the sequence and choosing the random WaveHand.

RoomB2 (OldWoman): idle by default, with a click triggering PickUpPhone → Calling → PutDownPhone → back to idle. One click to complete. Animation and click only for now; the three-click count and podcast audio are deferred.

RoomA1 (ToiletMan): a click plays the CloseWindow scream animation, which carries an Animation Event that fires a script method to drive the window's separate closing animation. Single direction, one click to complete; the opening animation is not built since the interaction is irreversible by design.

Began migrating the finished characters, animations, Animator Controllers, and scripts from GreyBoxing into the FinalYellowBuilding project. Idle animations play correctly after migration, but clicking does not yet work.


---

**Design Decisions**

- Two reusable room patterns confirmed. Pattern A (A2): random idle plus a single click-triggered one-shot action, using an AnyState transition and a bool, with idle switching driven by script. Pattern B (B1/B2): fixed-order multi-step sequences, using direct state-to-state transitions chained by Has Exit Time, with the script only starting the sequence and supplying branch parameters such as B1's random WaveIndex. The two are complementary and remaining rooms should map onto one of them
- Character-to-prop linkage handled via Animation Events (A1): the character animation fires a script method at a precise frame, which in turn drives the prop's Animator. This keeps timing frame-accurate and decouples character from prop. The C3 to C2 linkage can follow the same approach
- Idle random looping is driven by script, not Animator auto-transitions. Two conditions must hold: AnyState transitions disable Can Transition To Self, and clip length is read only after the transition finishes
- Any clip judged complete via normalizedTime must have Loop Time disabled, since a looping clip never reaches normalizedTime 1 and stalls the coroutine
- The one-shot trigger bool is cleared via a condition on the return transition, so the action holds on its last frame until the script clears the bool, eliminating the race between bool clearing and Has Exit Time
- Cross-project migration (GreyBoxing → Final) requires the click trio to be re-established in the target project: Physics Raycaster, EventSystem, the Input System module, and Layer / Event Mask are scene- or project-level and do not travel with the character prefab
- A2 simplified for now: dropped the lighting fade and three-click count from the original spec, implemented as a single-click Angery trigger. This conflicts with the current ARCHITECTURE description and needs to be reconciled later

---

**Pending — June 6**

- Resolve the click failure in the Final project after migration. Collider, Physics Raycaster, EventSystem, and script are all in place with no console errors, but OnPointerClick does not fire, so the ray is not reaching the character. Priority checks: whether the project uses the new Input System (EventSystem may need InputSystemUIInputModule), and whether the Physics Raycaster's Event Mask matches the character Layer. Note that Lisa's scene, materials, and lighting are not yet built, so characters will be repositioned later and the click issue should be retested then
- Replace the A1 ToiletMan script with the hasCompleted single-direction locked version
- Build the remaining rooms: A3 (the cat, with different behavior across the two modes, the most complex) and the C3 to C2 linkage (couple complains, dancers reduced by two, music fades out, reset after ten seconds)
- Add B2's three-click count and podcast audio later
- The Core trio (GameManager, CameraController, ClickDetector) remains unwritten; each room's ReportCompletion is currently a placeholder comment