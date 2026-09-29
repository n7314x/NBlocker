#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v xcodegen >/dev/null 2>&1; then
  "$repo_root/scripts/install-xcodegen.sh"
fi

xcodegen generate --spec "$repo_root/project.yml"

python3 - "$repo_root/Resources/Info/NBlocker-Info.plist" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as stream:
    info = plistlib.load(stream)

launch_screen = info.get("UILaunchScreen")
if not isinstance(launch_screen, dict) or launch_screen.get("UIColorName") != "LaunchBackground":
    raise SystemExit("error: generated Info.plist is missing the modern launch-screen configuration")

phone_orientations = info.get("UISupportedInterfaceOrientations")
if phone_orientations != ["UIInterfaceOrientationPortrait"]:
    raise SystemExit("error: generated Info.plist must restrict the iPhone app to portrait")
PY
