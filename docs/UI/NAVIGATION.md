# Navigation

The root owns five independent `NavigationStack` tabs in a native SwiftUI
`TabView(selection:)`, in this visual order:

1. Sleep (`moon.zzz`)
2. Activity (`chart.bar`)
3. Home (`house`, default)
4. Protection (`shield`)
5. Profile (`person.crop.circle`)

The native iOS 26 tab bar supplies Liquid Glass, selection semantics, safe-area
handling, and accessibility. `AppRouter.selectedTab` is the single source of truth,
so both tab taps and programmatic Home actions update the same selection. Full-screen
platform browsers cover the bar and provide their own close control. Settings use
large sheets so browser state remains alive beneath them when appropriate.

Home presents a paged horizontal `ScrollView` platform carousel rather than a nested
page `TabView`. Selecting the centered platform updates activity, account affordances,
accent light, and the settings card as one coherent transition. Launching a platform
never replaces its WebKit data store.
