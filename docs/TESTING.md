# Testing

`NBlockerTests` covers deterministic logic: Codable settings persistence, overnight
routine schedules and interval ends, Strict Mode delay boundaries, usage recovery
and aggregation, migration defaults, rule selection, and platform route
classification. `NavigationUITests` launches the app and verifies all five native
tabs plus Home's programmatic Activity and Protection transitions.

CI performs:

1. repository and resource lint (`scripts/lint.sh`), including JSON and JavaScript
   syntax checks;
2. XcodeGen project generation;
3. unsigned iOS Simulator build;
4. unit tests on an available iPhone simulator;
5. the root-navigation UI tests on that simulator.

Linux cannot type-check SwiftUI, WebKit, or UIKit against an iOS SDK. Local checks in
that environment validate shell syntax, YAML/JSON structure, JavaScript parsing, and
pure-source invariants. A passing Linux check is not reported as an Xcode build.
