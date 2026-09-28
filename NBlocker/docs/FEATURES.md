# Feature inventory

Legend: **M1** implemented in the first milestone, **Next** designed but incomplete,
**Later** deferred.

| Area | Capability | State |
| --- | --- | --- |
| Navigation | Sleep, Activity, Home, Protection, Profile | M1 |
| Home | Swipeable Instagram/YouTube launcher and per-platform settings | M1 |
| Browser | Persistent sessions, navigation, reload, home, external link, settings | M1 |
| Instagram | Hide Reels/Stories entries, block Reel routes, hide Explore/suggestions | M1 |
| YouTube | Hide Shorts entries/shelves, block Shorts/search routes, hide recommendations | M1 |
| Settings | Local Codable persistence and rule reload | M1 |
| Activity | App-contained sessions and local daily/weekly aggregates | M1 |
| Protection | Honest Screen Time capability status and planned controls | M1 |
| Icons | Official alternate-icon API and empty asset slots | M1 infrastructure; artwork needed |
| Routines | Schedule model and active-routine calculation | M1 core / Next UI |
| Strict Mode | Activation slider plus immediate, hold, delay, and routine-end override UI | M1 |
| Scroll control | Time/post reminders and follow-up allowances | Next |
| Screen Time | FamilyActivityPicker, shields, monitors | Later; entitlement-gated |
| Widgets/Live Activities | Shared models and isolated scaffold | Later |

Usage metrics cover only time and sessions inside NBlocker's own browser. A prevented
route increments only when a navigation decision is actually cancelled. NBlocker
does not claim device-wide social usage without Screen Time authorization.
