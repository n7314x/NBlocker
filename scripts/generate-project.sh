#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v xcodegen >/dev/null 2>&1; then
  "$repo_root/scripts/install-xcodegen.sh"
fi

xcodegen generate --spec "$repo_root/project.yml"
