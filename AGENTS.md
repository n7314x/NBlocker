# NBlocker Repository Instructions

NBlocker is a local-first iOS 26+ SwiftUI application built from `project.yml` with
XcodeGen. Preserve the existing top-level organization and read every file in
`docs/` before making architectural changes. Read the feature-specific documents
before changing Instagram, YouTube, Screen Time, build, signing, or UI behavior.

## Architecture

- Keep native app concerns in `NBlocker/`, web-page manipulation in
  `WebResources/`, shared extension-safe values in `Shared/`, privileged Screen
  Time extensions in `Extensions/`, and tests in `Tests/`.
- Keep WebKit lifecycle, navigation policy, settings, persistence, usage tracking,
  and bridge handling in Swift. Keep DOM observation, semantic element discovery,
  CSS filtering, and site cleanup in versioned JavaScript/CSS resource files.
- Never embed large JavaScript or CSS programs in Swift source. Rule resources
  must be modular, idempotent, defensive, individually selectable, and observable
  through privacy-safe event messages.
- Prefer small focused types, value models, protocol seams where they enable
  testing, dependency injection at system boundaries, `async`/`await`, Observation,
  `@MainActor` for UI state, `Sendable` where correct, and `OSLog` over `print`.
- Do not introduce global mutable state, force unwraps without a structural proof,
  giant view files, or abstractions with no current use.

## Product and design

- The visual direction is OLED black, opaque dark content cards, restrained
  platform-colored light, and native iOS 26 Liquid Glass for navigation and small
  interactive controls. Do not cover content-heavy settings surfaces in glass.
- Use the tokens in `NBlocker/DesignSystem` for spacing, radius, typography,
  animation, materials, and platform accents. Respect Reduce Motion and accessibility.
- SocialLite references inform hierarchy only. Never copy its source, proprietary
  assets, branding, wording, or pixel-level screen design.
- Do not commit Instagram or YouTube trademark artwork unless the user supplied it
  with permission. System-symbol fallback marks are intentional.

## Privacy and security

- NBlocker has no account, backend, ads, analytics, telemetry, or cloud browsing
  history. Store preferences, routines, and aggregate usage on device.
- Website credentials and cookies remain in WebKit's persistent data store. Never
  inspect, log, export, or manually store passwords or authentication tokens.
- Logs may contain rule identifiers, route categories, durations, and error types;
  never log full visited URLs, page text, message content, cookies, or account data.
- Describe app-controlled friction accurately. Do not claim that Strict Mode is
  tamper-proof or system-enforced when privileged Screen Time controls are absent.

## Build and distribution

- `project.yml` is the project source of truth. Do not hand-maintain or commit a
  generated `.xcodeproj` unless a documented exceptional workflow requires it.
- Routine development must work from a Chromebook: generation, compilation, and
  tests run in GitHub Actions on macOS. Scripts must be non-interactive and CI-safe.
- Sideloading is the primary distribution route. Do not add App Store Connect,
  TestFlight, receipt, or App Store-only assumptions without a documented reason.
- Secrets, certificates, provisioning profiles, passwords, and team IDs never enter
  the repository. Optional signed packaging reads them from GitHub Secrets.
- Normal app builds must compile and remain useful without Family Controls,
  Managed Settings, Device Activity, shield, widget, or Live Activity entitlements.
  Privileged targets are opt-in and isolated in `project.yml`.

## Style and tests

- Types use `UpperCamelCase`; methods, properties, and rule identifiers use
  `lowerCamelCase`; JavaScript rule IDs use dotted namespaces such as
  `instagram.reels.navigation`.
- Prefer structs and enums for data. Name boolean settings positively and make
  persisted models version-tolerant with defaults.
- Add or update tests for persistence, schedules, Strict Mode timing, usage
  aggregation, rule selection, route classification, and URL handling whenever
  those areas change. Web rule scripts need syntax checks and pure selector/route
  tests where practical.
- Before handing off changes, generate the project, lint resource syntax, and run
  all available tests. If Xcode is unavailable, say so plainly and rely on CI for
  the actual Apple-platform build.
