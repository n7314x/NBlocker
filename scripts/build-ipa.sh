#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="${NBLOCKER_BUILD_ROOT:-$repo_root/.build/ipa}"
output_path="${NBLOCKER_IPA_PATH:-$build_root/NBlocker-unsigned.ipa}"

"$repo_root/scripts/generate-project.sh"

xcodebuild \
  -project "$repo_root/NBlocker.xcodeproj" \
  -scheme NBlocker \
  -configuration Release \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -derivedDataPath "$build_root/DerivedData" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  clean build

app_path="$build_root/DerivedData/Build/Products/Release-iphoneos/NBlocker.app"
python3 - "$app_path/Info.plist" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as stream:
    info = plistlib.load(stream)

if info.get("UILaunchScreen", {}).get("UIColorName") != "LaunchBackground":
    raise SystemExit("error: built app is missing its modern launch-screen declaration")
if info.get("UISupportedInterfaceOrientations") != ["UIInterfaceOrientationPortrait"]:
    raise SystemExit("error: built app has an unexpected iPhone orientation configuration")
if set(info.get("UIDeviceFamily", [])) != {1, 2}:
    raise SystemExit("error: built app must remain universal for iPhone and iPad")
PY

"$repo_root/scripts/package-ipa.sh" "$app_path" "$output_path"

echo "This IPA is unsigned and must be signed by the installation workflow."
