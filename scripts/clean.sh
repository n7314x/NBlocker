#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$repo_root/.build"
project_path="$repo_root/NBlocker.xcodeproj"

if [[ -d "$build_root" ]]; then
  rm -rf "$build_root"
fi
if [[ -d "$project_path" ]]; then
  rm -rf "$project_path"
fi

echo "Removed generated project and repository-local build products."
