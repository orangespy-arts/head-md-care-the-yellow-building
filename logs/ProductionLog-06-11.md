**Work Log — June 11, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Built the in-game text display system (Pending item #3). Added a reusable `FloatingText` component — a world-space TextMeshPro label that sits above each character, with a small `ShowLine` / `ShowSequence` / `Hide` API and fade in/out. One instance per room, each on its own coroutine, so multiple rooms can show text at once without conflict. Wired it into the three speaking rooms:

- **WorkMan (A2)** — `ShowSequence` plays three anger lines when he gets angry.
- **Couple (C3)** — `ShowLine` shows one complaint per click.
- **OldWoman (B2)** — `ShowSequence` runs the phone subtitles once she picks up (`02-PickUpPhone`), paced to the podcast 1–3.

All three call `floatingText.Hide()` in `ResetRoom()`. The dialogue is exposed as `[TextArea] string[]` fields in the Inspector so the final French copy can be written without touching code. Language decided: **French** (echoing the title *L'Immeuble Jaune*); current strings are placeholders.

---

**Bug Fixes / Design Decisions**

- Decided on a single uniform display approach: world-space floating text above each room, rather than a shared bottom-of-screen subtitle. Reasons: it stays anchored to the room it belongs to, and it avoids collisions when several rooms are triggered at once — consistent with the project's "minimal code, simple logic" goal.
- Doc sync: `tech-log.md` still embedded the June 10 *pre-fix* `GameManager` (the `clickAction` version) and listed the Default-mode activity detection as a small pending item. The live code already uses `Pointer.current.press` in both branches. Annotated the stale code block and corrected the note. Also fixed the script table (`CatController.cs` → `Cat.cs`) and added the `FloatingText.cs` row.

---

**Unity editor steps still needed (code is ready)**

1. Add a **TextMeshPro - Text (3D)** child above each speaking character, facing +Z, sized/positioned to taste.
2. Drag it into the script's `Floating Text` field.
3. Use a font that includes French accents (é è ê ç à ù…). Default LiberationSans covers Latin-1; if swapping fonts, include those glyphs in the TMP Font Asset or they render as boxes.

---

**Pending — June 12**

- Text assets: create the TMP objects in-scene, wire references, write final French copy
- Final project integration: click-failure issue after migration
- Toon Shader config: change dancer disappearance to a fade-out
