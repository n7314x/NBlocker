# NBlocker

NBlocker is a local-first iOS 26+ SwiftUI application for intentional Instagram and
YouTube use. It combines a native settings/activity experience with persistent,
rule-controlled WebKit browsers.

The Xcode project is generated from `project.yml`; do not edit a generated project.
Routine development is designed for Chromebook + GitHub Actions:

```sh
make lint
git push
```

On macOS, `make bootstrap`, `make build`, and `make ipa` install/generate/build the
project. The IPA target is unsigned unless a separate signing workflow is configured.
See `docs/PRODUCT.md`, `docs/ARCHITECTURE.md`, and `docs/SIDeloading.md`.
