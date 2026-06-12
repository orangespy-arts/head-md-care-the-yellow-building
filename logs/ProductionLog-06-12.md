**Work Log — June 12, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Migrated all animations from the greybox scene into the final project. Each room's character animations now play inside the production scene with the correct hierarchy and references intact. Fixed several bugs uncovered during migration.

---

**lisa**

Implemented toon shaders for the scene. Materials updated across affected objects.

---

**Feedback — Davin room-light review session**

Ran a walkthrough with feedback; key notes:

- **Legibility** — players don't know what to do when they enter a room; need clearer affordance or entry cue.
- **Cat movement** — cat moves too much and distracts from room content; consider reducing idle animation frequency or range.
- **Cat interaction** — clicking the cat should trigger a jump; currently not wired or not obvious enough.
- **Interaction target size** — several clickable objects are too small to hit reliably; need to increase collider / hit area.
- **PDF** — print/export a PDF (likely for the exhibition handout or room-guide reference).

---

**Pending — June 13**

- Fix character positions in final scene (post-migration offsets)
- Wire camera-follow-cat shot (camera transitions to cat on interaction)
- Mount all music and sound effects to rooms
- Room disappear sequence at ending — verify or implement final dissolve
- Address Davin feedback: legibility cues, reduce cat idle motion, cat-click → jump, enlarge small interaction colliders
- Export exhibition PDF
