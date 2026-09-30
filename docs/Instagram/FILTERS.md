# Instagram filters

Resources load in this order: shared bootstrap, messaging, DOM observer, Instagram
bootstrap, base stylesheet, then feature rules. Rules remain dormant when their
setting is off so configuration changes can be applied to the live document without
a reload. A single observer batches DOM changes and targets affected subtrees;
feature rules do not each create polling timers.

Initial rules:

| Rule ID | Resource | Intent |
| --- | --- | --- |
| `instagram.reels.entries` | `reels.js` | Hide semantic Reel entry links/buttons |
| `instagram.explore.entries` | `explore.js` | Hide discovery content and explicit Explore entries while preserving Search |
| `instagram.feed.suggestions` | `suggested-posts.js` | Hide labeled suggestion containers |
| `instagram.feed.ads` | `ads.js` | Detect/hide labeled feed and Story promotions |
| `instagram.messages.only` | `messages.js` | Suppress non-message navigation in DM mode |
| `instagram.stories.entries` | `stories.js` | Hide semantic Story entry links |
| `instagram.search.results` | `search.js` | Conservatively filter post/profile search results |
| `instagram.scroll.reminders` | `scroll-reminders.js` | Report configured time/post thresholds |
| `instagram.appearance.grayscale` | `grayscale.js` | Apply selected grayscale scope |

Rules prefer stable URL patterns, roles, and accessible labels over generated class
names. Every hidden element is marked with `data-nblocker-hidden`. Live configuration
updates remove current hidden markers and then reapply enabled rules, so disabled
filters do not leave stale hidden elements. Exceptions emit only a rule ID to the
native bridge.

Instagram navigation discovery marks only a semantically identified navigation row
and its immediate item wrappers. When a destination is hidden, the marked mobile row
uses equal flexible widths so the remaining controls reflow without fixed empty
slots. Search semantics take precedence over the `/explore` route because Instagram
also uses that route for its mobile Search control; Explore filtering instead hides
explicit Explore controls and inactive discovery-grid content.

The ad and suggestion rules remain installed so the native metrics strip can show
real current-document counts. They report only numeric counts. The native “Block
these” action invokes an in-page action that marks the currently detected containers
with the same local hidden attribute.
