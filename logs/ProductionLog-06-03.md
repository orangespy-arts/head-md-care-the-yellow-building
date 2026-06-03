**Work Log — June 3, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Trimmed, renamed, and organized all DeepMotion animations into their Unity folders across RoomA1, A2, B1, B2, C2, and C3. Exported the dance animation from Meshy and completed the full pipeline for the RoomC2 dancers: animation binding, material application, and duplication to nine dancers. Finalized the entire interaction system architecture (GameManager, CameraController, ClickDetector, per-room Interactables). Ready to begin interaction scripting.

**lisa**

- Placed furniture for RoomA3 and RoomC2
- Built the opposing building view (the starting-scene apartment from which the player looks out)

---

**Design Decisions**

- Narrative structure confirmed: two mutually exclusive entry modes from the opening scene. Clicking the glass of water triggers Mode 1 (camera zooms to the nine-room grid, free clicking); clicking the cat triggers Mode 2 (camera follows the cat across balconies in fixed order). Both modes share the same room interactions and the same ending (building lights fade out one by one, then return to the opening scene)
- Click targets are the characters/objects themselves, not the windows, since the cat-following view in Mode 2 makes windows too large to click meaningfully
- "Completion" is judged per room: each room reports its own finished signal, and GameManager only counts signals without tracking internal click counts (A2 and B2 require three clicks, others one)
- Camera logic and room interaction logic kept fully separate so the two modes can share the same room scripts
- Cat behavior differs by mode: in Mode 1 the cat roams freely as ambient soft-guidance (clickable for a light reaction but not counted), in Mode 2 the cat is the clickable guide that advances to the next balcony and counts toward completion
- Completion targets differ by mode: Mode 1 counts 5 (A1/A2/B1/B2/C3), Mode 2 counts 6 (including the cat)
- Nine RoomC2 dancers reuse the same Meshy model and the same FunnyDancing animation, differences not noticeable under toon render style

---

**Pending — June 4**

- Write the Core trio in Claude Code: GameManager, CameraController, ClickDetector
- Define the Interactable interface/base class with a unified OnInteract() entry
- Write room scripts one by one, starting from RoomA1 (simplest)
- Define the cat's balcony order and per-stop room mapping for Mode 2 in the scene