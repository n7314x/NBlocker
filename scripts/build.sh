#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="${NBLOCKER_BUILD_ROOT:-$repo_root/.build}"

"$repo_root/scripts/generate-project.sh"

xcodebuild \
  -project "$repo_root/NBlocker.xcodeproj" \
  -scheme NBlocker \
  -configuration Debug \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$build_root/DerivedData" \
  CODE_SIGNING_ALLOWED=NO \
  clean build
