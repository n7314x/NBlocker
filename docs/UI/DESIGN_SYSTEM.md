# Design system

Tokens live in `NBlocker/DesignSystem/Tokens`:

- spacing: 4, 8, 12, 16, 24, and 32-point steps;
- radius: 12 for controls, 20 for cards, 28 for prominent surfaces;
- colors/materials: OLED black canvas, raised charcoal, quiet border, primary and
  secondary text, plus per-platform accents;
- type: system semantic styles and rounded monospaced digits for usage values;
- animations: one quick response, one interactive spring, one gentle content spring.

Reusable components include opaque cards, glass buttons/capsules, platform marks,
settings rows, usage rings/charts, the platform carousel, and the bottom bar.

All touch targets are at least 44 points. Selected states use shape, label, and color
rather than color alone. Dynamic Type may reflow cards; important values must not be
truncated to preserve a decorative layout.
