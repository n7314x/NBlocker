# Design system

Tokens live in `NBlocker/DesignSystem/Tokens`:

- spacing: compact 3, 6, 10, 14, 18, and 24-point steps, plus a 20-point screen
  inset and 28-point section rhythm;
- radius: 14 for controls, 22 for cards, 28 for prominent surfaces, and 32 for sheets;
- colors/materials: OLED black canvas, near-black reading surfaces, visible quiet borders, primary and
  secondary text, plus per-platform accents;
- type: system semantic styles and rounded monospaced digits for usage values;
- animations: one quick response, one interactive spring, one gentle content spring.

Reusable components include large-title screen headers, opaque outlined cards,
glass buttons/capsules, platform marks, settings rows, usage rings/charts, the
platform carousel, and a full-height root screen scroller. Root navigation remains
a native system component with icon-only labels and native selection semantics.

All touch targets are at least 44 points. Selected states use shape, label, and color
rather than color alone. Dynamic Type may reflow cards; important values must not be
truncated to preserve a decorative layout.
