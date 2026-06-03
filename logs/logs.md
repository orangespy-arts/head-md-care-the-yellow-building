# Development Log — The Yellow Building

This log documents the key milestones and decision points in the development of the project. Each entry reflects a significant moment in the conceptual, narrative, or technical progression of the work.

## 06-02
**06-02**
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