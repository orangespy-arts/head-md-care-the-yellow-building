# Log — The Yellow Building

This log documents the key milestones and decision points in the development of the project. Each entry reflects a significant moment in the conceptual, narrative, or technical progression of the work.


## 06-16

The Yellow Building was presented in its final form. The complete four-state cycle — Screensaver → Interactive → Dissolving → Ending — ran end to end on the venue device, with the room audio and podcast all working smoothly in situ.

## 06-15

Returning after the weekend, this was the content-and-polish push that closed the remaining gaps before the exhibition. zhanlan integrated the room audio, remuxing Lisa's radio-station and podcast tracks, and confirmed all nine rooms were ready for deployment.

Details:

[Production Log 06-15](ProductionLog-06-15.md)

## 06-1314

Weekend — no work.

## 06-12

All animations were migrated from the greybox scene into the final project, completing the last major scene-transfer task. All room characters now animate correctly in the production environment; miscellaneous polish tasks remain but the core is complete.

Details:

[Production Log 06-12](ProductionLog-06-12.md)

## 06-11

The four-state cycle (Screensaver → Interactive → Dissolving → Ending) came together completely in a single day, well ahead of schedule. zhanlan built the FloatingText system: a world-space TextMeshPro label engine with ShowLine / ShowSequence / Hide methods, allowing room dialogue to be driven by string arrays.

Details:

[Production Log 06-11](ProductionLog-06-11.md)

## 06-10

The cat system and the Core architecture both came together, leaving all nine rooms interactive in GreyBoxing. The A3 cat's position and orientation bug was fixed (Humanoid rig / Generic clip conflict resolved by rebuilding the cat rig).

Details:

[Production Log 06-10](ProductionLog-06-10.md)

## 06-0809

C3/C2 rooms completed and A3 cat begun. RoomC3 (Couple) uses two synchronized Animator Controllers triggered on the same frame, with a simplified single-loop idle state replacing the original three-clip model.

Details:

[Production Log 06-0809](ProductionLog-06-0809.md)

## 06-0405

Four rooms scripted and working over the past two days (A1, A2, B1, B2), and two reusable interaction patterns validated for the rooms still to come. RoomA2 (WorkMan) established the first pattern — repeated clicks progressively affecting internal state; RoomA1 (ToiletMan) established the second — a single click triggering an event sequence and locking input until reset.

Details:

[Production Log 06-0405](ProductionLog-06-0405.md)

## 06-03

Ahead of schedule again. All animations were trimmed, renamed, and organized into Unity folders across all rooms. The RoomC2 dancer pipeline was completed in full — animation binding, material assignment, texture application, and sequencing all verified in the greybox.

Details:

[Production Log 06-03](ProductionLog-06-03.md)

## 06-02

Ahead of schedule again. All 15 character models were imported into Unity with Humanoid Rig configured, and motion capture recordings were completed for RoomA1, A2, B1, B2, C2, and C3, covering 23 animation clips.

Details:
- [Production Log 06-02](ProductionLog-06-02.md)

## 06-01

Today we moved faster than [planned v1](Production-plan-variation/Production-plan-v1.md) — rigging was completed a full day ahead of schedule, the entire production pipeline shifted forward by 24 hours.

Details:
- [Production Log 06-01](ProductionLog-06-01.md)
- [Moodboard](../media/MoodBoardYellowBuilding.pdf)

## 05-29

Created a comprehensive asset list and established the final project folder structure in Unity. The asset list covers all nine rooms and includes 3D models for characters and furniture, animation sequences, UI elements, and audio assets.

Relevant files:
- [Asset List](AssetList.md)
- [Final Project](../unity/Final_YellowBuilding)

## 05-25

Developed the full narrative production document for all nine apartments. Each room was given a distinct resident persona, emotional state, and a sequence of up to five actions that unfold over time, establishing the narrative backbone for all future interactions.

Relevant files:
- [yellow_building_production_en.pdf](../media/yellow_building_production_en.pdf)

## 05-22

Developed and implemented the interaction scripts for each of the nine rooms. Each window responds independently to player input while some rooms are interconnected, creating a sense of a living building:

- **RoomA1:** Clicking the window triggers a sound reaction and closes the window.
- **RoomA2:** Repeated clicks progressively affect the worker's behavior, culminating in a text-based emotional response before resetting.
- **RoomA3:** Clicking the cat triggers a movement animation across windows, with the cat eventually eating at the B2 balcony.
- **RoomB1:** Clicking reveals a child's random gestures, followed by the appearance of moving boxes suggesting departure.
- **RoomB2:** Clicking triggers a phone conversation in sequence, playing podcast audio across three stages.
- **RoomC2/C3:** Clicking RoomC3 causes the couple to react to the dancing in RoomC2, progressively reducing the number of people and lowering the music volume until silence, then resetting after 10s.

This session established the core interactive logic of the project and defined the relationship between individual rooms and the building as a whole.

## 05-20 to 05-21

Built the greybox model of the yellow building, including both the exterior facade and interior spaces. The facade is structured as a 3x3 grid of nine windows, each representing a different resident.

- [GreyBoxing](../unity/GreyBoxing)

## 05-19

Presented the concrete interaction concept: the window as the primary narrative device. Drawing from the autoethnographic method established earlier, the "window" represents the subjective viewpoint of the site itself, filtered through spatial perspective and architectural framing.

## 05-07

Developed the narrative framework and project intentions. Defined the protagonist Augustin as a genderless, ageless persona embodying collective memory. Established the main plot: the last day before demolition, with memories surfacing as physical traces in the space.

Relevant files:
- [05-07-Intentions](Intentions.md)

## 05-06

Conducted field interviews with people in front of the yellow building, including the owner of a nearby restaurant. The interviews revealed a contrast between temporary occupants and long-term residents, and how the building's pending demolition affected their relationship to the space.

Relevant files:
- [05-06-Interview&Drawing](https://www.notion.so/05-06-Interview-Drawing-359992e01f9d808398d0fffb1d0f6c8a?pvs=21)

## 04-30

Discussed narrative strategy for the project: how to introduce social and political themes around urban demolition and displacement through a gentle, intimate storytelling approach rather than direct advocacy or messaging.

## 04-29

Selected the core subject of the project: an old yellow building facing demolition in Geneva. The choice was motivated by its personal significance and its broader resonance with issues of urban displacement, collective memory, and architectural loss.
