# The Yellow Building — User Journey

*Last updated: June 12, 2026*

---

## Overview

The experience runs as a continuous four-state loop. No input is required to begin — the installation starts itself and returns to its idle state after each cycle.

```
State 1 (Screensaver)
    → any click →
State 2 (Interactive)
    → all rooms visited, or 45 s of no input →
State 3 (Dissolving)
    → automatic →
State 4 (Ending)
    → automatic →
State 1 (Screensaver)
```

---

## State 1 — Screensaver

The building is alive but no one is watching. The cat moves autonomously across the balconies, jumping from window to window on the 3×3 facade. The camera slowly pushes in toward whichever window the cat is near, revealing interior detail. The building breathes on its own.

**Trigger to advance:** any click anywhere on screen.

---

## State 2 — Interactive

The player is now inside the viewpoint apartment, looking across at the yellow building. Each of the nine windows can be clicked. Five windows contain interactive characters; the other windows are ambient. All five rooms must be visited — or the player must go idle for 45 seconds — to end this state.

### Room A1 — ToiletMan

> *Click this window.*

The man behind the window screams. The window slams shut. A flush sound plays. The window stays closed.

**Completion trigger:** first click.

---

### Room A2 — WorkMan

> *Click this window repeatedly.*

Each click dims the room's light slightly. After three clicks the room is dark and the worker's posture shifts — he has had enough. Angry words appear as floating text above him. After 3 seconds, the light comes back and he resets to his original state.

**Completion trigger:** third click (anger state reached).

---

### Room A3 — Cat

> *Click the cat.*

The cat jumps to a random window elsewhere on the facade. It moves with a full jump animation and lands cleanly. When the path takes it past the B2 balcony, it stops to eat from a food bowl there.

*The cat is also the screensaver actor in State 1. In State 2 it becomes a clickable object the player can redirect.*

**Completion trigger:** none — the cat is ambient interaction, not a completion room.

---

### Room B1 — Kid

> *Click this window.*

The child looks up from whatever he was doing. Each click produces a different random gesture or animation. He holds the pose for 2–3 seconds, then looks back down. After his sequence is complete, cardboard moving boxes appear in the room — he is leaving.

**Completion trigger:** kid looks up (first click).

---

### Room B2 — OldWoman

> *Click this window.*

The old woman picks up the phone. A podcast plays — a recorded voice, in French. Each subsequent click advances to the next segment of the podcast (1 → 2 → 3). The woman's animation tracks the phone conversation throughout.

**Completion trigger:** phone picked up (first click).

---

### Room C3 — Couple (linked to Room C2)

> *Click this window.*

The couple complains about the noise from the dancers in Room C2 next door. First click: one partner reacts, one dancer disappears from C2 and the music drops slightly. Second click: the other partner reacts, another two dancers leave C2 and the music drops further. This continues until Room C2 is empty and silent. After 10 seconds, everything resets — the dancers return, the music comes back, and the couple goes quiet.

**Completion trigger:** second click (both partners have complained).

---

### Rooms B3, C1, C2 — Ambient

These windows have no direct click interaction. Room C2 (the dancers) responds only through the C3 Couple script — its state is driven entirely by what happens next door.

---

## State 3 — Dissolving

No input is needed or accepted. The building begins to disappear. Room contents fade out one by one — objects, furniture, figures — room by room across the facade, with each room staggered so the dissolve ripples outward rather than cutting all at once. The cat hides. The building empties itself.

---

## State 4 — Ending

The camera pulls back to a wide shot of the building exterior. The cat appears on a windowsill, sitting still. The light dims slowly. The screen fades to black. A beat of silence.

Then the loop restarts from State 1.

---

## Notes

- Language: all floating text and podcast audio is in French (*L'Immeuble Jaune*).
- The 45-second idle timeout in State 2 is a fallback for exhibition contexts where visitors may walk away mid-interaction; the loop continues without human input.
- `debugSkipScreensaver` must be **off** before exhibition; idle threshold must be set to **45 s**.
