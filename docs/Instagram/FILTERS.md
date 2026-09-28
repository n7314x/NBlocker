# Instagram filters

Resources load in this order: shared bootstrap, messaging, DOM observer, Instagram
bootstrap, base stylesheet, then enabled feature rules. A single observer batches DOM
changes and targets affected subtrees; feature rules do not each create polling timers.

Initial rules:

| Rule ID | Resource | Intent |
| --- | --- | --- |
| `instagram.reels.entries` | `reels.js` | Hide semantic Reel entry links/buttons |
| `instagram.explore.entries` | `explore.js` | Hide Explore navigation entry points |
| `instagram.feed.suggestions` | `suggested-posts.js` | Hide labeled suggestion containers |
| `instagram.messages.only` | `messages.js` | Suppress non-message navigation in DM mode |
| `instagram.stories.entries` | `stories.js` | Hide semantic Story entry links |
| `instagram.appearance.grayscale` | `grayscale.js` | Apply selected grayscale scope |

Rules prefer stable URL patterns, roles, and accessible labels over generated class
names. Every hidden element is marked with `data-nblocker-hidden`; reloading rules
reloads the page into a fresh document so disabled filters do not leave stale hidden
elements. Exceptions emit only a rule ID to the native bridge.
