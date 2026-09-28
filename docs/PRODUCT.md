# Product

NBlocker is a local-first iPhone app that offers useful, signed-in Instagram and
YouTube experiences without their most compulsive surfaces. It combines native
configuration and activity views with controlled, persistent `WKWebView` sessions.

The first milestone supports two platforms:

- Instagram with configurable Reels, Explore, suggested-content, messaging, and
  appearance rules.
- YouTube with configurable Shorts, Home recommendations, autoplay, comments, and
  appearance rules.

NBlocker does not proxy either service and does not ask for social credentials.
Authentication happens on the original website in WebKit and remains in WebKit's
persistent website data store.

## Product principles

1. Preserve intentional use: messaging, account lookup, subscriptions, search, and
   long-form content should stay usable when the user chooses them.
2. Reduce loops: infinite short-form sequences, recommendations, and autoplay are
   the first targets.
3. Fail open safely: a stale selector may leave site content visible, but must not
   crash the native app or expose private data.
4. Be honest about enforcement: native Screen Time controls are stronger but depend
   on Apple-granted capabilities; WebKit filtering is app-scoped friction.
5. Keep data local: no NBlocker account, backend, advertising, analytics, or remote
   telemetry is required.

## First milestone acceptance

The repository generates an iOS 26 project, builds a five-tab SwiftUI application,
opens persistent Instagram and YouTube browsers, applies switchable local rules,
tracks app-contained sessions, persists settings, explains Screen Time capability
state, and runs logic tests in GitHub Actions.

The milestone is a foundation, not a claim that every planned selector or protected
system-app workflow is production-complete.
