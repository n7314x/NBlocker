# Animation

Animation timings are centralized in `NBAnimation`:

- `quick`: short ease-out for opacity and small control feedback;
- `interactive`: responsive spring for direct manipulation and tab/carousel changes;
- `content`: restrained spring for cards and value changes;
- `sheet`: native sheet behavior, with SwiftUI presentation detents.

The selected carousel item scales modestly while neighbors recede. Associated content
crossfades and moves only a few points. Numeric usage values use a numeric content
transition. Tab selection and carousel snapping produce light selection feedback.
Strict Mode activation uses a deliberate drag and a strong success haptic.

When Reduce Motion is enabled, large scale/offset and matched transitions are replaced
by opacity changes. No animation exists solely to keep the screen moving.
