# Log — The Yellow Building

This log documents the key milestones and decision points in the development of the project. Each entry reflects a significant moment in the conceptual, narrative, or technical progression of the work.


## 06-16

The Yellow Building was presented in its final form. The complete four-state cycle — Screensaver → Interactive → Dissolving → Ending — ran end to end on the venue device, with the room audio, single-audio exclusivity, the engagement-based idle behaviour, and the window-based interaction all in place. The project shipped.

## 06-15

Returning after the weekend, this was the content-and-polish push that closed the remaining gaps before the exhibition. zhanlan integrated the room audio, remuxing Lisa's radio-station and podcast tracks — MP3 streams wrapped in an `.mpeg` container that Unity's video importer had rejected — losslessly into `.mp3` AudioClips. OldWoman (B2) was reworked into a click-to-toggle podcast: she picks up the phone and plays from the start, a second click sets the phone down and pauses in place, a third picks the phone back up and resumes from the same position, and when the podcast finishes she hangs up on her own and the room reports complete. A new A3 RadioStation room was added — a light bulb and radio whose click turns the bulb on with an emissive glow and plays the looping station, sharing the same pause/resume-from-position behaviour. An audio-exclusivity coordinator was introduced so only one sound plays at a time: starting the radio sets the old woman's phone down and pauses her podcast, and vice versa, each resuming from its own position. The State4 ending was built out: the cat now lands on a table in the facing apartment, the camera zoom-out became a precise eased duration with an adjustable height, and the "yellow building goes dark while the bedroom stays lit" effect — after trying sun/ambient fades and a full-screen black canvas — settled on a perspective-correct 3D black plane outside the window that stays transparent until after the zoom-out, making it resolution-independent. Idle behaviour was split by engagement: a visitor who never touches anything returns to the screensaver after a short idle, while a visitor who has interacted gets the full ending after a longer one, with "clicked at least once" as the signal so someone standing and listening to the multi-minute podcast is never cut off. The cat's mid-air spawn at startup was fixed, and it gained two speed profiles — a calmer screensaver pace and a livelier interactive one — plus an adjustable follow height. For reliable tapping on the venue iPad, every room's click target was moved off the small character and onto the large window, with each room script relocated to its window and the character Animator wired in by reference, plus a small relay so ToiletMan's CloseWindow animation event still reaches the relocated script. The FloatingText subtitle system was formally cancelled — the speaking rooms play animation and audio only. Lisa produced the presentation PDF and provided the edited audio assets. Updated to [Production Plan v10](logs/Production-plan-variation/Production-plan-v10.md).

Details:

[Production Log 06-15](logs/ProductionLog-06-15.md)

## 06-1314

Weekend — no work.

## 06-12

All animations were migrated from the greybox scene into the final project, completing the last major scene-transfer task. All room characters now animate correctly in the production environment; misc bugs uncovered during migration were fixed. Lisa implemented toon shaders for the scene and materials were updated across affected objects. A walkthrough with feedback highlighted legibility issues, cat movement frequency, cat-click responsiveness, small interaction target sizes, and the need for an exhibition PDF. Updated to [Production Plan v9](logs/Production-plan-variation/Production-plan-v9.md).

Details:

[Production Log 06-12](logs/ProductionLog-06-12.md)

## 06-11

The four-state cycle (Screensaver → Interactive → Dissolving → Ending) came together completely in a single day, well ahead of schedule. zhanlan built the FloatingText system: a world-space TextMeshPro label component with ShowLine / ShowSequence / Hide API, wired into the three speaking rooms (WorkMan, Couple, OldWoman). Fixed a documentation sync issue, ensuring tech-log.md reflected the live code. Completed the State3 dissolve sequence with a flat rooms[9] array on GameManager and per-room fade-out staggering, and verified the State4 ending sequence with full loops restoring cleanly. Updated to [Production Plan v8](logs/Production-plan-variation/Production-plan-v8.md).

Details:

[Production Log 06-11](logs/ProductionLog-06-11.md)

## 06-10

The cat system and the Core architecture both came together, leaving all nine rooms interactive in GreyBoxing. The A3 cat's position and orientation bug was fixed (Humanoid rig / Generic clip conflict), and the cat was given parabolic jump displacement with proper landing animation. GameManager was written with Default / Screensaver two-mode architecture and IRoomResettable interface. CameraController was completed with screensaver push-in and cat-follow logic. The screensaver exit bug was fixed (trackpad tap-to-click now properly detected via Pointer.current.press instead of Mouse-only channel), and screensaver entry no longer cuts in mid-interaction due to the same fix in the idle timer logic. All five room scripts were updated with IRoomResettable, interaction blocking, and per-room ResetRoom(). Updated to [Production Plan v7](logs/Production-plan-variation/Production-plan-v7.md).

Details:

[Production Log 06-10](logs/ProductionLog-06-10.md)

## 06-0809

C3/C2 rooms completed and A3 cat begun. RoomC3 (Couple) uses two synchronized Animator Controllers triggered on the same frame, with a simplified single-loop idle state replacing the original three-click sequence. RoomC2 (Dancers) features nine synchronized dancers performing the same looping dance, with the couple's click (C3) triggering a progressive reduction in dancer count and volume. The cat system was initialized with jump animations, landing states, and multi-window traversal. Updated to [Production Plan v6](logs/Production-plan-variation/Production-plan-v6.md).

Details:

[Production Log 06-0809](logs/ProductionLog-06-0809.md)

## 06-0405
Four rooms scripted and working over the past two days (A1, A2, B1, B2), and two reusable interaction patterns validated for the rooms still to come. RoomA2 (WorkMan) established the first pattern — random idle looping with a click-triggered one-shot action (AnyState plus a bool) — and surfaced a full set of Animator and coroutine pitfalls that are now documented (Can Transition To Self, Loop Time breaking normalizedTime, redundant conditions, bool clearing timing, the click trio). RoomB1 (Boy) and RoomB2 (OldWoman) established the second pattern for sequence-type rooms, chaining states directly with Has Exit Time. RoomA1 (ToiletMan) used an Animation Event to link the character's scream animation to the window's separate closing animation. Began migrating the finished rooms from GreyBoxing into the Final project; idle plays correctly but clicking does not yet work after migration — suspected Input System module or Physics Raycaster Event Mask, deferred until Lisa's scene exists since characters will be repositioned. Remaining: A3 (the cat) and the C3/C2 linkage, plus the still-unwritten Core trio. Updated to [Production Plan v5](logs/Production-plan-variation/Production-plan-v5.md).

Details:

[Production Log 06-0405](logs/ProductionLog-06-0405.md)

## 06-03
Ahead of schedule again. All animations were trimmed, renamed, and organized into Unity folders across all rooms. The RoomC2 dancer pipeline was completed in full — animation binding, material application, and duplication to nine dancers. The opposing building view (the opening scene apartment) was built by Lisa, along with furniture placement for RoomA3 and RoomC2. The full interaction system architecture was finalized (GameManager, CameraController, ClickDetector, per-room Interactables), and the narrative structure confirmed: two entry modes triggered by the glass of water or the cat, converging on the same room interactions and ending. Ready to begin scripting on June 4. Updated to [Production Plan v4](logs/Production-plan-variation/Production-plan-v4.md).

Details:

[Production Log 06-03](logs/ProductionLog-06-03.md)

## 06-02
Ahead of schedule again. All 15 character models were imported into Unity with Humanoid Rig configured, and motion capture recordings were completed for RoomA1, A2, B1, B2, C2, and C3, covering 23 animation states in a single day. Lisa participated in the RoomC3 recording session and completed model import and furniture placement for RoomB1, RoomB3, and RoomC3, along with updated window models across the facade. Key design decisions included simplifying RoomB2 to a single looping phone animation, switching to DeepMotion standard models for better Unity Humanoid compatibility, and omitting finger grip animation due to model rig limitations. Dance animations remain the only pending item for June 3. Updated to [Production Plan v3](logs/Production-plan-variation/Production-plan-v3.md).

Details:
- [Production Log 06-02](logs/ProductionLog-06-02.md)

## 06-01
Today we moved faster than [planned v1](logs/Production-plan-variation/Production-plan-v1.md)  — rigging was completed a full day ahead of schedule, the entire production pipeline shifted forward by one day, and the UX flow documentation was also finished. All 15 character models were generated using Nano Banana and Meshy AI, rigged in Meshy AI, and their Unity import workflow validated. The character pipeline shift from Ready Player Me (inaccessible network) to Nano Banana + Meshy AI + FBX export was completed. RoomC2 was redesigned from 2 characters to 9 dancers, and the couple in RoomC3 was redesigned as a lesbian couple. Dance animations sourced directly from Meshy AI, eliminating motion capture for that sequence. All remaining animations will use DeepMotion Animate 3D instead of Perception Neuron hardware, cancelling the June 3 mocap day. Furniture placement completed for RoomA1, RoomA2, RoomB1, and RoomB3 by Lisa. Updated to [Production Plan v2](logs/Production-plan-variation/Production-plan-v2.md).

Details:
- [Production Log 06-01](logs/ProductionLog-06-01.md)
- [Moodboard](media/MoodBoardYellowBuilding.pdf)

## 05-29
Created a comprehensive asset list and established the final project folder structure in Unity. The asset list covers all nine rooms and includes 3D models for characters and furniture, animation sequences, materials, sound effects, UI text assets, and complete script organization. All nine rooms have been hierarchically structured in the project, with clearly defined folder organization for future asset integration.

Relevant files:
- [Asset List](logs/AssetList.md)
- [Final Project](unity/FinalYellowBuilding)

## 05-25
Developed the full narrative production document for all nine apartments. Each room was given a distinct resident persona, emotional state, and a sequence of up to five actions that unfold over time, creating a cohesive narrative arc for the building as a whole.

Relevant files:
- [yellow_building_production_en.pdf](media/yellow_building_production_en.pdf)

## 05-22
Developed and implemented the interaction scripts for each of the nine rooms. Each window responds independently to player input while some rooms are interconnected, creating a sense of a living building with shared moments:

- **RoomA1:** Clicking the window triggers a sound reaction and closes the window.
- **RoomA2:** Repeated clicks progressively affect the worker's behavior, culminating in a text-based emotional response before resetting.
- **RoomA3:** Clicking the cat triggers a movement animation across windows, with the cat eventually eating at the B2 balcony.
- **RoomB1:** Clicking reveals a child's random gestures, followed by the appearance of moving boxes suggesting departure.
- **RoomB2:** Clicking triggers a phone conversation in sequence, playing podcast audio across three stages.
- **RoomC2/C3:** Clicking RoomC3 causes the couple to react to the dancing in RoomC2, progressively reducing the number of people and lowering the music volume until silence, then resetting after 10 seconds.

This session established the core interactive logic of the project and defined the relationship between individual rooms and the building as a whole.

## 05-20 to 05-21
Built the greybox model of the yellow building, including both the exterior facade and interior spaces. The facade is structured as a 3x3 grid of nine windows, each representing a different resident. Interior rooms were modeled with basic geometry to establish spatial relationships and allow for early animation testing.

- [GreyBoxing](unity/GreyBoxing)

## 05-19
Presented the concrete interaction concept: the window as the primary narrative device. Drawing from the autoethnographic method established earlier, the "window" represents the subjective viewpoint of each resident. Clicking on a window allows the player to discover the intimate moments and hidden lives within the building, establishing the core mechanic of the project.

## 05-07
Developed the narrative framework and project intentions. Defined the protagonist Augustin as a genderless, ageless persona embodying collective memory. Established the main plot: the last day before the building is demolished, with the player discovering how each resident prepares for departure and how memories are preserved.

Relevant files:
- [05-07-Intentions](logs/Intentions.md)

## 05-06
Conducted field interviews with people in front of the yellow building, including the owner of a nearby restaurant. The interviews revealed a contrast between temporary occupants and long-term residents, and highlighted the emotional and practical challenges of urban displacement.

Relevant files:
- [05-06-Interview&Drawing](https://www.notion.so/05-06-Interview-Drawing-359992e01f9d808398d0fffb1d0f6c8a?pvs=21)

## 04-30
Discussed narrative strategy for the project: how to introduce social and political themes around urban demolition and displacement through a gentle, intimate storytelling approach rather than direct messaging or didactic framing.

## 04-29
Selected the core subject of the project: an old yellow building facing demolition in Geneva. The choice was motivated by its personal significance and its broader resonance with issues of urban displacement, gentrification, and collective memory.
