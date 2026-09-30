# Instagram features

## Milestone 1

- persistent website session and native browser navigation;
- intentional preference-application launch state with retryable load failure UI;
- Home-only session/detection status above the webpage and a floating
  browser-controls surface;
- enable/disable filtering without clearing session data;
- hide Reels navigation/feed/profile entry points and optional Reel URL blocking;
- best-effort Reel autoplay attribute removal, muting, and next-Reel click prevention;
- hide semantic Story entry links;
- hide Explore entry points;
- suggested-post filtering framework using accessible text and structural hints;
- privacy-safe detected ad/suggestion counts and a one-tap hide-visible action;
- conservative sponsored feed/Story filtering and optional post-search filtering;
- DMs-only configuration architecture and inbox home route;
- grayscale/media-grayscale hooks and rule reload;
- time/post scroll reminders delivered through the native browser message surface;
- settings grouped into Blocking, Feed, Reels, Stories, Messages, Search/Explore,
  Profiles, Appearance, and Scroll Control. Remaining unimplemented fine-grained
  controls are visibly disabled rather than presented as working.

## Planned

Single Reel mode will admit one explicitly shared Reel identifier while preventing
next-Reel navigation. Story progression and more precise promotional detection
require broader on-device fixture validation. Account management intentionally hands
off to Instagram's own signed-in WebKit page rather than inspecting account identity.
