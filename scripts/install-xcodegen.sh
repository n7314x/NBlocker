#!/usr/bin/env bash
set -euo pipefail

if command -v xcodegen >/dev/null 2>&1; then
  xcodegen --version
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "error: Homebrew is required to install XcodeGen" >&2
  exit 1
fi

brew install xcodegen
xcodegen --version
