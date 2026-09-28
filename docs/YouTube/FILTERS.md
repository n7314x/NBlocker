# YouTube filters

YouTube uses the same shared observer/registry as Instagram. Rules respond to both
DOM mutations and YouTube's single-page navigation events without installing
continuous polling.

| Rule ID | Resource | Intent |
| --- | --- | --- |
| `youtube.shorts.entries` | `shorts.js` | Hide Shorts tabs/buttons/shelves |
| `youtube.home.recommendations` | `home.js` | Reduce the Home recommendation feed |
| `youtube.watch.recommendations` | `recommendations.js` | Hide related/end suggestions |
| `youtube.playback.autoplay` | `autoplay.js` | Disable supported autoplay controls |
| `youtube.search.suggestions` | `search.js` | Hide semantic search suggestion rows |
| `youtube.comments.hidden` | `comments.js` | Hide comment sections |
| `youtube.appearance.grayscale` | `grayscale.js` | Apply the selected grayscale scope |

Selectors favor href patterns, custom-element names, roles, and accessible labels.
Unknown DOM is left untouched rather than broadly deleting content containers.
The native navigation guard independently blocks `/shorts/` and `/results` routes
when their settings require it.
