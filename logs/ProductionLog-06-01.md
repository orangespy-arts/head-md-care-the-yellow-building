**June 1, 2026 — Work Log**

**Original Plan:** Zhanlan: generate 6 character models on Ready Player Me, export FBX. Lisa: furniture assets for RoomA1.

---

**Zhanlan**

Ready Player Me was inaccessible from the current network. After researching alternatives, a new character pipeline was established: Nano Banana and Meshy AI (concept image generation) → Meshy AI (image to 3D, rigging, animation library) → FBX export → Unity.

Completed today:
- Generated concept images for all 15 characters using Nano Banana and Meshy AI: 6 main characters (ToiletMan, WorkMan, Kid, OldWoman, Couple1, Couple2) and 9 dancers for RoomC2
- Generated all 15 3D models and completed rigging in Meshy AI
- Validated full Unity import workflow: FBX import, Humanoid Rig setup, Animator Controller configuration, animation playback confirmed working

Key decisions made:

RoomC2 updated from 2 characters to 9 dancers to better reflect a party atmosphere and cultural diversity. RoomC3 couple redesigned as a lesbian couple. Dance animations (Dance 1-12) will be sourced directly from Meshy AI's built-in animation library, eliminating the need for motion capture for this sequence. All remaining animations will use DeepMotion Animate 3D (video-to-animation) instead of Perception Neuron hardware. June 3 mocap day is cancelled.

Interaction list documented: 

RoomA1 WindowClose, RoomA2 BotherWorker, RoomA3 CatBehaviour, RoomB1 KidBehaviour, RoomB2 OldWomanTalk.

---

**Lisa**

Exceeded original plan. [Completed moodboard and color palette research](media\MoodBoardYellowBuilding.pdf). Completed UX experience flow documentation:

Entry experience: visitor approaches iPad and sees Davin's window view, project title, and a zoom into the building facade. The hidden lives behind neighbors' windows are the content to be discovered — nothing reveals itself immediately.

Interaction model: clickable items are visually differentiated through a glowing effect. The cat's movement, sound from RoomC2, and glowing items serve as natural invitations to interact. No explicit tutorial. If the visitor does nothing, ambient animations continue playing. First successful interaction gives the visitor a sense of inclusion in the building's life, encouraging further exploration. The story loops like one day in the building — entry point is Davin's window.

Furniture placement completed for RoomA1, RoomA2, RoomB1, and RoomB3, ahead of schedule. Materials and textures pending further refinement.

---

**Tomorrow:**

Zhanlan: batch import all remaining models into Unity following the validated workflow, begin animation sourcing via DeepMotion Animate 3D and Meshy AI.
Lisa: continue furniture assets for remaining rooms, begin material refinement.