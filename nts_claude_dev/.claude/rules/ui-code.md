---
paths:
  - "prototypes/*/Scripts/UI/**"
  - "**/Assets/Scripts/UI/**"
---

# UI Code Rules (Unity)

- UI must NEVER own or directly modify game state — display only, use C# events/Actions to request changes
- Input follows the game profile in `<stt>_claude.md`: touch-first for mobile (all interactive elements reachable by touch via EventSystem); add keyboard/mouse/gamepad only if the game targets them
- All animations/tweens (e.g., DOTween) must be killable/skippable on `OnDestroy` to prevent memory leaks
- UI sounds trigger through the audio event system, not directly via `AudioSource.Play` in the UI script
- UI must never block the game thread (use coroutines or async/await for heavy loading)
- Scalable text (Canvas Scaler) is mandatory, not optional
- Test all Canvas screens at minimum and maximum supported resolutions
