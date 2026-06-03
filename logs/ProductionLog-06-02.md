**Work Log — June 2, 2026**
**Project: The Yellow Building**

---

**zhanlan**

Batch imported all 15 character models into Unity with Humanoid Rig configured. Completed motion capture recordings for RoomA1, A2, B1, B2, and C2, covering a total of 16 animation states. Dance animations and retargeting remain pending for June 3.

**lisa**

- Participated in motion capture recording for RoomC3
- Imported models and placed furniture for RoomB1, RoomB3, RoomC3
- Updated window models across the building facade

---

**Design Decisions**

- RoomB2 idle state requires no animation, character holds default pose
- OldWoman phone interaction: click to toggle audio playback (podcast-style, resumes from last position); Phone1/2/3 consolidated into one looping phone animation
- Finger grip animation omitted, Boy model has no finger rig, detail not visible in toon render style
- Switched to DeepMotion built-in standard models for motion capture, then retarget to project characters for better Unity Humanoid compatibility
- Purchased DeepMotion Innovator plan ($48/month, 480 credits) to avoid multi-account ToS risk

---

**Pending — June 3**

- Export Dance1-9 from Meshy (9 clips)
- Trim, rename, and organize all DeepMotion animations into correct Unity folders