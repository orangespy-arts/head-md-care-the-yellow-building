# The Yellow Building · L'Immeuble Jaune

> *The Yellow Building, where I live, / where I lived, / where will I live?*
> *L'immeuble jaune, où je vis, / où je vivais, / où vais-je vivre?*

A tablet based interactive story about an old yellow building on the last day before it is demolished. Visitors look across at the building through a neighbouring window, peering into nine lit rooms and the small rituals of the people inside — until, one by one, the rooms dissolve and the building empties itself into the dark.

**Status:** in production for a final exhibition on **June 16, 2026**.

---

## Concept

It is the last day of the old yellow building. Tomorrow it will be torn down by greedy landlords. The people who have spent their lives here take care of their homes one final time — repairing, cleaning, arranging flowers — even knowing everything will disappear the next day.

The piece asks a simple question: *if this building is demolished, what happens to the memories of the people who lived here?* Rather than tell that story head-on, the installation lets a visitor poke at the building's windows and watch its inhabitants react, then quietly takes it all away.

See `logs/Intentions.md` and `logs/Narrative.md` for the full intention and narrative notes.

---

## The Experience

The installation runs as a continuous, self-restarting **four-state loop**. No input is required to begin; after each cycle it returns to its idle state.

```
State 1  Screensaver  ──any click──▶
State 2  Interactive  ──all rooms visited, or 45s idle──▶
State 3  Dissolving   ──automatic──▶
State 4  Ending       ──automatic──▶
State 1  Screensaver  (loop)
```

| State | What happens |
|-------|--------------|
| **1 · Screensaver** | The building is alive but unwatched. A cat jumps autonomously across the 3×3 window facade; the camera slowly pushes in toward whichever window it lands near. |
| **2 · Interactive** | The visitor looks across from the viewpoint apartment. Nine windows; five hold interactive characters. The state ends when all five rooms have been visited, or after 45s of no input. |
| **3 · Dissolving** | No input accepted. Room contents fade out one by one, room by room, rippling across the facade. The cat hides. The building empties. |
| **4 · Ending** | The camera pulls back to a wide exterior shot. The cat appears on a windowsill. The light dims, the screen fades to black, a beat of silence — then the loop restarts. |

### The nine rooms

| Room | Character | Interaction |
|------|-----------|-------------|
| **A1** | ToiletMan | Click → he screams, the window slams shut, a flush plays. |
| **A2** | WorkMan | Click repeatedly → the light dims each click; after 3 clicks he snaps and angry words float above him, then it resets. |
| **A3** | Cat | Click → the cat jumps to a random window; passing B2 it stops to eat. (Also the screensaver actor.) |
| **B1** | Kid | Click → he looks up with a random gesture, holds 2–3s, looks back down; moving boxes appear (he's leaving). |
| **B2** | OldWoman | Click → she picks up the phone; a French podcast plays, advancing 1→2→3 on each click. |
| **C3** | Couple | Click → they complain about the dancers next door; each click removes dancers from **C2** and lowers its music, until C2 is silent. Resets after 10s. |
| **B3 · C1 · C2** | — | Ambient. C2 (the dancers) is driven entirely by the C3 script. |

All floating text and podcast audio are in **French**. Full per-room detail is in `logs/UserJourney.md`.

---

## Repository Layout

```
.
├── README.md
├── unity/
│   ├── FinalYellowBuilding/   # production project (exhibition build)
│   └── GreyBoxing/            # greybox prototype (state-machine core authored here)
├── logs/                      # Obsidian vault — design docs & production journal
└── media/                     # concept art, mood boards, podcast transcript, PDFs
```

> **Note:** `logs/` is an Obsidian vault. Per-device workspace state is git-ignored (see `.gitignore`); the markdown notes themselves are tracked.

### Key documents in `logs/`

| File | Contents |
|------|----------|
| `Architecture-Todo-0611.md` | The four-state architecture and the live build TODO — **read this first when resuming work.** |
| `UserJourney.md` | State-by-state and room-by-room walkthrough of the visitor experience. |
| `Production-plan-v9.md` | Latest production plan, team responsibilities, and day-by-day schedule. |
| `Intentions.md` / `Narrative.md` | Story intention and narrative design. |
| `AssetList.md` | Full asset hierarchy (animations, models, sounds, texts, scripts). |
| `Style.md` | Visual style reference (Unity Toon Shader). |
| `ProductionLog-06-*.md`, `logs.md` | Daily production journal. |
| `credit-furniture.md` | Third-party asset credits and licenses. |

---

## Technical Overview

- **Engine:** Unity **6000.3.15f1** (Unity 6), URP, new Input System, Unity Toon Shader.
- **Two projects:** the state-machine **core** (GameManager, CameraController, Cat, FloatingText, per-room controllers) was authored in `GreyBoxing/` and is being migrated into `FinalYellowBuilding/` for the exhibition build.

**Architecture highlights:**

- `GameManager` — owns the `GameState` enum (`Screensaver / Interactive / Dissolving / Ending`), the idle timeout, completion tracking with deduplication, the `rooms[9]` dissolve array, and the fade-to-black + reset cycle.
- `CameraController` — screensaver cat-follow push-in, smooth zoom-out on exit, and the dual position/rotation lerp into the ending shot.
- `FloatingText` — world-space TextMeshPro labels with `ShowLine` / `ShowSequence` / `Hide`; dialogue is exposed as `[TextArea] string[]` so French copy can be entered without touching code.
- Rooms implement a shared resettable interface so the whole installation can return cleanly to State 1 on every loop.

### Opening the project

1. Install **Unity 6000.3.15f1** (via Unity Hub).
2. Open `unity/FinalYellowBuilding/` for the exhibition build, or `unity/GreyBoxing/` for the prototype.
3. The main scene lives under `Assets/Scenes/`.

> `Library/`, `Temp/`, `Logs/`, and other generated Unity folders are local build artifacts and should not be relied on across machines.

### Exhibition checklist (before showing)

- Turn **off** `debugSkipScreensaver`; confirm the idle threshold is **45s**.
- Test a **Windows full-screen build** (not just the editor).
- Verify clicks on the on-site touch screen / trackpad.
- Configure auto-launch on boot and rehearse power-loss recovery.
- Run an unattended 30-minute loop and confirm no accumulated errors or memory growth.

---

## Team

| | Responsibilities |
|---|---|
| **zhanlan** | Character modelling, rigging & animation, interaction scripts, text assets, four-state game architecture, dissolve & ending systems. |
| **lisa** | Furniture & scene assembly, building materials/textures, exterior props, lighting, sound import & mounting, toon shaders. |

See `logs/Production-plan-v9.md` for the full breakdown.

---

## Credits

Third-party models are used under Creative Commons Attribution licenses — full attributions in `logs/credit-furniture.md`.
