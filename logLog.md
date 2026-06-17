# Log — The Yellow Building

This log documents the key milestones and decision points in the development of the project. Each entry reflects a significant moment in the conceptual, narrative, or technical progression of the work.


## 06-16

The Yellow Building was presented in its final form. The complete four-state cycle — Screensaver → Interactive → Dissolving → Ending — ran end to end on the venue device, with the room audio, single-audio exclusivity, the engagement-based idle behaviour, and the window-based interaction all in place. The project shipped.

## 06-15

Returning after the weekend, this was the content-and-polish push that closed the remaining gaps before the exhibition. zhanlan integrated the room audio, remuxing Lisa's radio-station and podcast tracks — MP3 streams wrapped in an `.mpeg` container that Unity's video importer had rejected — losslessly into `.mp3` AudioClips. OldWoman (B2) was reworked into a click-to-toggle podcast: she picks up the phone and plays from the start, a second click sets the phone down and pauses in place, a third picks the phone back up and resumes from the same position, and when the podcast finishes she hangs up on her own and the room reports complete. A new A3 RadioStation room was added — a light bulb and radio whose click turns the bulb on with an emissive glow and plays the looping station, sharing the same pause/resume-from-position behaviour. An audio-exclusivity coordinator was introduced so only one sound plays at a time: starting the radio sets the old woman's phone down and pauses her podcast, and vice versa, each resuming from its own position. The State4 ending was built out: the cat now lands on a table in the facing apartment, the camera zoom-out became a precise eased duration with an adjustable height, and the "yellow building goes dark while the bedroom stays lit" effect — after trying sun/ambient fades and a full-screen black canvas — settled on a perspective-correct 3D black plane outside the window that stays transparent until after the zoom-out, making it resolution-independent. Idle behaviour was split by engagement: a visitor who never touches anything returns to the screensaver after a short idle, while a visitor who has interacted gets the full ending after a longer one, with "clicked at least once" as the signal so someone standing and listening to the multi-minute podcast is never cut off. The cat's mid-air spawn at startup was fixed, and it gained two speed profiles — a calmer screensaver pace and a livelier interactive one — plus an adjustable follow height. For reliable tapping on the venue iPad, every room's click target was moved off the small character and onto the large window, with each room script relocated to its window and the character Animator wired in by reference, plus a small relay so ToiletMan's CloseWindow animation event still reaches the relocated script. The FloatingText subtitle system was formally cancelled — the speaking rooms play animation and audio only. Lisa produced the presentation PDF and provided the edited audio assets. Updated to [Production Plan v10](logs/Production-plan-v10.md).

Details:

[Production Log 06-15](logs\ProductionLog-06-15.md)

## 06-1314

Weekend — no work.

## 06-12

All animations were migrated from the greybox scene into the final project, completing the last major scene-transfer task. All room characters now animate correctly in the production environment; miscellaneous bugs surfaced during migration were fixed. Lisa implemented toon shaders, updating materials across the affected objects. A room-light review session with Davin produced four UX findings to address before the exhibition: visitors do not know what to do on room entry and need a clearer affordance; the cat's idle movement is too frequent and distracts from the room content; clicking the cat should trigger a jump but is not yet wired or visible enough; and several clickable objects have colliders too small to hit reliably. A PDF exhibition handout was also flagged as a deadline item. Updated to [Production Plan v9](logs/Production-plan-v9.md).

Details:

[Production Log 06-12](logs\ProductionLog-06-12.md)

## 06-11

The four-state cycle (Screensaver → Interactive → Dissolving → Ending) came together completely in a single day, well ahead of schedule. zhanlan built the FloatingText system: a world-space TextMeshPro label per room with a ShowLine / ShowSequence / Hide API, fade in/out, and independent coroutines so multiple rooms can display text simultaneously without conflict. It is wired into WorkMan (A2), OldWoman (B2), and Couple (C3), with dialogue exposed as Inspector string arrays so the final French copy can be entered without touching code. The two-state architecture was expanded to four states: GameState enum with Screensaver, Interactive, Dissolving, and Ending; RegisterInteractive / ReportCompletion API; 45-second idle timeout; and deduplication-safe completion tracking across the five interactive rooms. The State3 dissolve system was built around a `rooms[9]` GameObject array on GameManager — each slot is an empty parent whose direct children disappear sequentially at a configurable interval, with rooms staggered so dissolves can overlap; initial active-state memory prevents props that started hidden from being wrongly re-enabled on reset. The State4 ending placed the ending room, a camera anchor, and a cat windowsill perch; CameraController lerps both position and rotation to the ending shot; Cat.cs gained AppearAt(perch); a CanvasGroup-based full-screen fade-to-black dims the sun and screen cleanly, and ResetAll restores everything before returning to State1. A frame rate regression from the com.unity.ai.assistant pre-release package (network-authorization loop) was found and fixed by removing the package. Cat animation was restored to the June 10 state. The complete four-state loop was verified across three consecutive runs with no anomalies. Lisa edited and trimmed all audio assets and made visual adjustments to the scene. Updated to [Production Plan v8](logs/Production-plan-v8.md).

Details:

[Production Log 06-11](logs\ProductionLog-06-11.md)

## 06-10

The cat system and the Core architecture both came together, leaving all nine rooms interactive in GreyBoxing. The A3 cat's position and orientation bug was fixed (Humanoid rig / Generic clip conflict resolved, orientation driven by a dedicated facingTarget empty), parabolic jump displacement and a landing animation were added, and the cat now drives the screensaver autonomously. The Core system was written end to end: GameManager with a two-mode Default / Screensaver architecture, an IRoomResettable interface that resets every room on exit, and CameraController handling the screensaver push-in plus a smooth, symmetric zoom-out on the way back. All five room scripts were batch-updated to implement IRoomResettable, block interaction during the screensaver, and provide a ResetRoom(). Two screensaver bugs were tracked down and fixed, both rooted in the same surprise: on a laptop, trackpad tap-to-click does not register on the Mouse channel in the new Input System, so neither the exit click nor the idle-reset was firing — switching detection to Pointer.current.press (the common base of Mouse/Pen/Touchscreen) made it a true screensaver that only triggers on genuine idle. Lisa modeled all the exterior planters around the building and authored the building's textures. Updated to [Production Plan v7](logs/Production-plan-v7.md).

Details:

[Production Log 06-10](logs\ProductionLog-06-10.md)

## 06-0809

C3/C2 rooms completed and A3 cat begun. RoomC3 (Couple) uses two synchronized Animator Controllers triggered on the same frame, with a simplified single-loop idle state replacing the original three-clip Talk cycle. Two clicks complete the room: the first plays Wait/Complain, the second plays Complain/Wait, then locks. RoomC2 dancer-reduction linkage implemented with public Inspector-assigned arrays and adjustable timing parameters; dancers disappear one by one starting at a configurable point in the complaint animation (SetActive for now, fade-out deferred until Toon Shader is configured). A3 cat redesigned from an interactive object into a screensaver trigger: after a period of no input the cat jumps autonomously between balconies on a 3x3 grid while the camera pushes in to reveal room detail, with any click exiting back to normal mode. Jump loop logic is written with legal-neighbor validation (column must change, row difference at most one, no straight vertical jumps), but the cat's position and orientation after teleporting to a balcony are currently broken and carry over to June 10. Lisa completed scene assembly for all nine rooms and built the C3 banner model. Gold is no longer available; text assets move to zhanlan and audio to lisa. Updated to [Production Plan v6](logs/Production-plan-v6.md).

Details:

[Production Log 06-0809](logs\ProductionLog-06-0809.md)

## 06-0405
Four rooms scripted and working over the past two days (A1, A2, B1, B2), and two reusable interaction patterns validated for the rooms still to come. RoomA2 (WorkMan) established the first pattern — random idle looping with a click-triggered one-shot action (AnyState plus a bool) — and surfaced a full set of Animator and coroutine pitfalls that are now documented (Can Transition To Self, Loop Time breaking normalizedTime, redundant conditions, bool clearing timing, the click trio). RoomB1 (Boy) and RoomB2 (OldWoman) established the second pattern for sequence-type rooms, chaining states directly with Has Exit Time. RoomA1 (ToiletMan) used an Animation Event to link the character's scream animation to the window's separate closing animation. Began migrating the finished rooms from GreyBoxing into the Final project; idle plays correctly but clicking does not yet work after migration — suspected Input System module or Physics Raycaster Event Mask, deferred until Lisa's scene exists since characters will be repositioned. Remaining: A3 (the cat) and the C3/C2 linkage, plus the still-unwritten Core trio. Updated to [Production Plan v5](logs\Production-plan-v5.md).

Details:

[Production Log 06-0405](logs\ProductionLog-06-0405.md)

## 06-03
Ahead of schedule again. All animations were trimmed, renamed, and organized into Unity folders across all rooms. The RoomC2 dancer pipeline was completed in full — animation binding, material application, and duplication to nine dancers. The opposing building view (the opening scene apartment) was built by Lisa, along with furniture placement for RoomA3 and RoomC2. The full interaction system architecture was finalized (GameManager, CameraController, ClickDetector, per-room Interactables), and the narrative structure confirmed: two entry modes triggered by the glass of water or the cat, converging on the same room interactions and ending. Ready to begin scripting on June 4. Updated to [Production Plan v4](logs\Production-plan-v4.md).

Details:

[Production Log 06-03](logs\ProductionLog-06-03.md)

## 06-02
Ahead of schedule again. All 15 character models were imported into Unity with Humanoid Rig configured, and motion capture recordings were completed for RoomA1, A2, B1, B2, C2, and C3, covering 23 animation states in a single day. Lisa participated in the RoomC3 recording session and completed model import and furniture placement for RoomB1, RoomB3, and RoomC3, along with updated window models across the facade. Key design decisions included simplifying RoomB2 to a single looping phone animation, switching to DeepMotion standard models for better Unity Humanoid compatibility, and omitting finger grip animation due to model rig limitations. Dance animations remain the only pending item for June 3. Updated to [Production Plan v3](logs\Production-plan-v3.md).

Details:
- [Production Log 06-02](logs\ProductionLog-06-02.md)

## 06-01
Today we moved faster than [planned v1](logs\Production-plan-v1.md1)  — rigging was completed a full day ahead of schedule, the entire production pipeline shifted forward by one day. The main breakthrough was establishing a new character workflow using Nano Banana and Meshy AI, replacing Ready Player Me, which resulted in all 15 character models being generated, rigged, and validated in Unity in a single day. Lisa also exceeded her plan, completing furniture placement for four rooms and producing the full UX flow documentation. The key strategic decision was to replace Perception Neuron motion capture entirely with DeepMotion Animate 3D and Meshy AI's animation library, simplifying the pipeline and freeing up June 3. So we make the [Production plan v2](logs\Production-plan-v2.md)

Details:
- [Production Log 06-01](logs\ProductionLog-06-01.md)
- [Moodboard](media\MoodBoardYellowBuilding.pdf)

## 05-29
Created a comprehensive asset list and established the final project folder structure in Unity. The asset list covers all nine rooms and includes 3D models for characters and furniture, animation sequences for each interactive character, sound assets, text assets, and interaction scripts. In total the project requires models for six distinct character types, over thirty animation states, multiple sound layers per room, and a set of cross-room interaction dependencies. This session translated the production document from 05-25 into a concrete development plan and defined the remaining workload for the production phase.

Relevant files:
- [Asset List](https://github.com/orangespy-arts/head-md-care-the-yellow-building/blob/main/logs/AssetList.md)
- [Final Project](https://github.com/orangespy-arts/head-md-care-the-yellow-building/blob/main/unity/FinalYellowBuilding)

## 05-25
Developed the full narrative production document for all nine apartments. Each room was given a distinct resident persona, emotional state, and a sequence of up to five actions that unfold over time, ending with a departure that reflects a different relationship to loss and displacement. The nine stories range from a mechanic who left without a word, to a 78-year-old woman who has lived there her entire life. The document also established cross-room narrative connections, for example the relationship between the translator in Room 1 and the elderly resident in Room 5, and the musician in Room 6 whose party affects the lawyer and bookseller in Room 3. This session translated the earlier conceptual and interaction work into a concrete production framework for the remaining development.

Relevant files:
- [yellow_building_production_en.pdf](https://github.com/orangespy-arts/head-md-care-the-yellow-building/blob/main/media/yellow_building_production_en.pdf)

## 05-22
Developed and implemented the interaction scripts for each of the nine rooms. Each window responds independently to player input while some rooms are interconnected, creating a sense of a living building where actions in one space affect another. The scripts include:

- **RoomA1:** Clicking the window triggers a sound reaction and closes the window.
- **RoomA2:** Repeated clicks progressively affect the worker's behavior, culminating in a text-based emotional response before resetting.
- **RoomA3:** Clicking the cat triggers a movement animation across windows, with the cat eventually eating at the B2 balcony.
- **RoomB1:** Clicking reveals a child's random gestures, followed by the appearance of moving boxes suggesting departure.
- **RoomB2:** Clicking triggers a phone conversation in sequence, playing podcast audio across three stages.
- **RoomC2/C3:** Clicking RoomC3 causes the couple to react to the dancing in RoomC2, progressively reducing the number of people and lowering the music volume until silence, then resetting after 10 seconds.

This session established the core interactive logic of the project and defined the relationship between individual rooms and the building as a whole.

## 05-20 to 05-21
Built the greybox model of the yellow building, including both the exterior facade and interior spaces. The facade is structured as a 3x3 grid of nine windows, each representing a different resident: an elderly person, a child, a young adult, a couple, a pet owner, and an already-vacated empty room, among others. This diversity was intentional, reflecting how demolition and displacement affect people across different social backgrounds, ages, and life situations. Interior spaces were also roughed out to support the interaction logic developed in the following session.

- [GreyBoxing](https://github.com/orangespy-arts/head-md-care-the-yellow-building/tree/main/unity/GreyBoxing)

## 05-19
Presented the concrete interaction concept: the window as the primary narrative device. Drawing from the autoethnographic method established earlier, the "window" represents the subjective viewpoint of the narrator, looking out from their own apartment toward the yellow building opposite. Each window of the yellow building becomes a portal into a different resident's story and memory. This framing allows the audience to inhabit a specific perspective rather than observe from a neutral distance, reinforcing the personal and intimate tone of the project.

## 05-07
Developed the narrative framework and project intentions. Defined the protagonist Augustin as a genderless, ageless persona embodying collective memory. Established the main plot: the last day before demolition, in which the inhabitant performs everyday rituals of care knowing everything will disappear. Brainstormed interaction concepts around fragmented memory, objects as carriers of time, and the relationship between bodily routine and place. Finalized the project title in both English and French.

Relevant files:
- [05-07-Intentions](https://github.com/orangespy-arts/head-md-care-the-yellow-building/blob/main/logs/Intentions.md)

## 05-06
Conducted field interviews with people in front of the yellow building, including the owner of a nearby restaurant. The interviews revealed a contrast between temporary occupants and long-term residents: the restaurant owner expressed indifference to the demolition, noting he could easily relocate his business, while acknowledging that the actual inhabitants of the building would face serious difficulties. This distinction between those with mobility and those without became a key thematic reference point for the project.

Relevant files:
- [05-06-Interview&Drawing](https://www.notion.so/05-06-Interview-Drawing-359992e01f9d808398d0fffb1d0f6c8a?pvs=21)

## 04-30
Discussed narrative strategy for the project: how to introduce social and political themes around urban demolition and displacement through a gentle, intimate storytelling approach rather than direct critique. The focus was on finding a tone that allows the audience to arrive at the themes through personal and emotional experience rather than confrontation.

## 04-29
Selected the core subject of the project: an old yellow building facing demolition in Geneva. The choice was motivated by its personal significance and its broader resonance with issues of urban displacement and memory. Defined the central research questions: what happens to the memories embedded in a place when it is destroyed, and can daily rituals serve as a form of preservation? Chose autoethnography as the primary method, using one specific case to reflect on wider patterns of urban change in Geneva and beyond.
