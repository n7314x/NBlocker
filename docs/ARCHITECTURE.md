# Architecture

## Layers

```text
SwiftUI features -> observable app environment -> local stores
        |                     |
        v                     v
 WebViewModel -> navigation guard + RuleEngine -> bundled WebResources
        |
        v
 persistent WKWebsiteDataStore (site-owned authentication)
```

- `NBlocker/App`: composition root, routing, scene lifecycle, dependency ownership.
- `NBlocker/Features`: screens and feature-scoped presentation logic.
- `NBlocker/Core`: Codable domain models, storage, logging, and utilities.
- `NBlocker/DesignSystem`: visual tokens and reusable native components.
- `NBlocker/Web`: WebKit lifecycle, route policy, script loading, and the rule model.
- `WebResources`: reviewed JavaScript, CSS, and content-blocker resources copied into
  the app bundle without being represented as Swift string literals.
- `NBlocker/Focus`: session timing, aggregate usage, reminders, and Strict Mode.
- `NBlocker/ScreenTime`: capability facade and status UI. It imports no privileged
  framework in the default build.
- `Extensions`: opt-in privileged targets that are excluded from the default scheme
  until signing capabilities are provisioned.
- `Shared`: app-group-safe constants/models for the app and future extensions.

## State ownership

`AppEnvironment` is a `@MainActor @Observable` composition object injected through
SwiftUI's environment. It owns stores, the usage tracker, and capability service.
Views edit value-type settings through the store; the store encodes each model as a
single version-tolerant Codable value in `UserDefaults`. Browser view models install
the platform rule runtime at launch and send changed configuration into the current
document without rebuilding or reloading the web view. WebKit's default persistent
website data store preserves site sessions without NBlocker handling credentials.
The browser model owns its live `WKWebView`, allowing SwiftUI sheet presentation and
representable lifecycle changes to reuse the same page, history, and JavaScript state.

## Rule engine

Each rule has a stable ID, platform, resource name, and injection time. Platform
providers install the complete dormant-capable runtime so a setting can be enabled
or disabled in the current document; `RuleEngine` composes it with shared rules and
loads UTF-8 resources.
Shared bootstrap/messaging/observer scripts load before platform rules. Navigation
guards independently classify URLs, so route blocking does not depend on DOM shape.

JavaScript uses a single scheduled `MutationObserver`; small mutation batches scan
only affected parent subtrees while larger batches fall back to one document scan.
Rules run through an idempotent registry. Events crossing the bridge contain only
allowlisted event names, rule IDs, route categories, scroll direction, and a
validated first-party path used to synchronize single-page navigation—not page
content, query values, or fragments. Missing elements and selector errors are
isolated per rule.

## Optional capabilities

The default `NBlocker` target intentionally has no Family Controls entitlement.
`ScreenTimeCapabilityService` reports `notProvisioned` unless an opt-in build setting
and entitled target are added. Device Activity, shield, and widget files remain
isolated future targets. This prevents ordinary sideloaded builds from failing code
signing while retaining the intended extension boundaries.

## Dependencies

There are no third-party runtime dependencies. XcodeGen is a build-time tool.
