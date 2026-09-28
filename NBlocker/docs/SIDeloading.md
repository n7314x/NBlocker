# Sideloading

The primary build product is an iOS archive exported or repackaged as an IPA for a
sideloading tool. The default workflow creates an unsigned simulator/device build
artifact for validation. A usable on-device IPA still needs signing accepted by the
device and the selected installer.

`scripts/build-ipa.sh` currently builds with code signing disabled and packages the
device `.app` into a `Payload/` directory. This is an **unsigned IPA artifact**, not
an installable or entitlement-bearing claim; a sideloading tool or later signing
workflow must sign it before installation. A certificate/profile-driven export flow
is intentionally deferred until repository secrets and a concrete signing method are
configured.

The workflow never assumes App Store Connect or TestFlight. Do not add certificates,
profiles, export option files containing team data, or passwords to Git.

Routine Chromebook workflow: edit/push -> CI installs XcodeGen -> generate project ->
build/test on `macos-26` -> download logs/artifacts from GitHub Actions.
