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
single version-tolerant Codable value in `UserDefaults`. Browser view models snapshot
enabled rules whenever a browser opens or settings are reloaded. WebKit's default
persistent website data store preserves site sessions without NBlocker handling
credentials.

## Rule engine

Each rule has a stable ID, platform, resource name, injection time, and a settings
predicate. Platform-specific providers select Instagram and YouTube rules;
`RuleEngine` composes them with shared rules and loads UTF-8 resources.
Shared bootstrap/messaging/observer scripts load before platform rules. Navigation
guards independently classify URLs, so route blocking does not depend on DOM shape.

JavaScript uses a single scheduled `MutationObserver`; small mutation batches scan
only affected parent subtrees while larger batches fall back to one document scan.
Rules run through an idempotent registry. Events crossing the bridge contain only allowlisted event
names, rule IDs, route categories, and scroll direction—not page content or URLs.
Missing elements and selector errors are isolated per rule.

## Optional capabilities

The default `NBlocker` target intentionally has no Family Controls entitlement.
`ScreenTimeCapabilityService` reports `notProvisioned` unless an opt-in build setting
and entitled target are added. Device Activity, shield, and widget files remain
isolated future targets. This prevents ordinary sideloaded builds from failing code
signing while retaining the intended extension boundaries.

## Dependencies

There are no third-party runtime dependencies. XcodeGen is a build-time tool.
