# Testing

`NBlockerTests` covers deterministic logic: Codable settings persistence, overnight
routine schedules and interval ends, Strict Mode delay boundaries, usage recovery
and aggregation, migration defaults, rule selection, and platform route
classification. UI-test files remain reserved for stable high-value flows; no UI
test is currently claimed as implemented.

CI performs:

1. repository and resource lint (`scripts/lint.sh`), including JSON and JavaScript
   syntax checks;
2. XcodeGen project generation;
3. unsigned iOS Simulator build;
4. unit tests on an available iPhone simulator.

Linux cannot type-check SwiftUI, WebKit, or UIKit against an iOS SDK. Local checks in
that environment validate shell syntax, YAML/JSON structure, JavaScript parsing, and
pure-source invariants. A passing Linux check is not reported as an Xcode build.
