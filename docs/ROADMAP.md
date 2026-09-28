# Roadmap and implementation checklist

This is the running checklist. Checked items must have implementation in the tree;
an unchecked item is not silently represented as complete in the UI.

## Milestone 1 — compiling foundation

- [~] XcodeGen configuration and xcconfig files (statically validated; macOS generation pending)
- [~] iOS 26 SwiftUI application target (implemented; first Xcode compile pending)
- [x] reusable design tokens and components
- [x] five-tab navigation with Home selected by default
- [x] platform carousel, launch actions, usage summary, routine card
- [x] Activity, Protection, Sleep, and Profile screens
- [x] Instagram and YouTube settings sheets
- [x] version-tolerant persistent settings, routine, and usage models
- [x] WebKit browser infrastructure and floating native toolbar
- [x] route classification, HTTPS upgrades, authentication hosts, and navigation blocking
- [x] modular Instagram and YouTube filtering resources
- [x] session usage tracking, interrupted-session recovery, and local aggregation
- [~] alternate icon API and catalog slots (original artwork and build declarations absent)
- [x] Screen Time capability status with normal-build fallback
- [~] CI and unsigned IPA workflows (validated locally; no Git remote exists to run them)
- [~] logic-focused unit tests (implemented; iOS test execution pending)
- [x] synchronized product, design, feature, platform, and build documentation
- [x] Strict Mode activation and policy-aware native override flow

## Milestone 2 — filtering resilience and routines

- [ ] fixture-driven DOM rule tests and selector health diagnostics
- [ ] Single Reel/Short allow-once flows for explicitly shared links
- [~] DMs-only navigation filtering and inbox route; account switching UX remains
- [~] schedule model and active selection; editor, conflicts, and application engine remain
- [ ] scroll reminders with time and measurable-content triggers
- [~] privacy-safe OSLog rule errors exist; an in-app diagnostics surface remains

## Milestone 3 — provisioned system protection

- [!] opt-in entitled application flavor — blocked on provisioning/signing capability
- [!] FamilyActivityPicker and token persistence — blocked on the entitled flavor
- [!] Device Activity schedules and reports — blocked on provisioning and device validation
- [!] Managed Settings shields, configuration, and actions — blocked on provisioning
- [!] signed extension targets and on-device entitlement verification — blocked on signing assets
- [~] widget and Live Activity scaffolds are isolated; product integration is deferred

## Recovery validation — 2026-09-28

- [x] JSON, plist, entitlement, shell, YAML, JavaScript, workflow, and Swift syntax checks pass
- [x] invalid empty asset metadata and stale-session accounting repaired
- [x] per-feature web rules honor their individual settings and fail conservatively
- [!] Xcode build/test run — no Xcode is installed locally and this checkout has no Git remote
