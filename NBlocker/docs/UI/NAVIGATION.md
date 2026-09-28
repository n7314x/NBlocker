# Navigation

The root owns five independent `NavigationStack` tabs in this visual order:

1. Sleep (`moon.zzz`)
2. Activity (`chart.bar`)
3. Home (`house`, default)
4. Protection (`shield`)
5. Profile (`person.crop.circle`)

A custom native bottom bar uses Liquid Glass and remains visible on root screens.
Full-screen platform browsers cover it and provide their own close control. Settings
use large sheets so browser state remains alive beneath them when appropriate.

Home presents a paged, swipeable platform carousel. Selecting the centered platform
updates activity, account affordances, accent light, and the settings card as one
coherent transition. Launching a platform never replaces its WebKit data store.
