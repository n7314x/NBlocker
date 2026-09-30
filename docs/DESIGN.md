# Design direction

NBlocker uses true black as the canvas, charcoal cards for readable information,
quiet one-pixel borders, and small areas of platform color. Instagram uses a warm
magenta accent and YouTube uses red; neither becomes a full-screen brand gradient.

Native iOS 26 Liquid Glass belongs on controls that float over content: the system
tab bar, web toolbar, compact buttons, and sheet actions. Large settings groups stay
opaque. Standard SwiftUI sheets provide native drag and dismissal behavior.

Typography favors system large titles and rounded numeric display text. The main
hierarchy is title, primary value/action, explanatory label, then grouped controls.
Motion is short and physical: selected platforms scale slightly, values transition,
and controls use restrained interactive springs. Reduce Motion replaces spatial
motion with fades.

The supplied SocialLite screenshots are limited to visual hierarchy and interaction
reference. NBlocker keeps its own copy, symbols, platform marks, local data, motion,
privacy model, and implementation while adopting the reference set's compact dark
composition, outlined surfaces, icon-only navigation, and sheet hierarchy.
