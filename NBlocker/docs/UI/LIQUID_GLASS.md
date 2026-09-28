# Liquid Glass

The deployment target is iOS 26, so NBlocker uses the native SwiftUI
`glassEffect(_:in:)`, `GlassEffectContainer`, and glass button styles. Glass appears
on the bottom navigation, browser toolbar, compact buttons, capsules, selector
controls, and transient overlays.

Glass is applied after sizing and foreground styling so its shape and interaction
response are correct. Groups of nearby toolbar items share a `GlassEffectContainer`
to render efficiently and morph naturally. Platform color is a subtle tint, never an
opaque branded panel.

Long settings forms, charts, warnings, and text-heavy cards use opaque `NBCard`
surfaces for contrast. Native sheets are not given an additional full-screen glass
layer. Accessibility contrast and Reduce Transparency remain more important than the
decorative effect.
