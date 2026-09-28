#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 /path/to/NBlocker.app /path/to/NBlocker.ipa" >&2
  exit 64
fi

app_path="$1"
output_path="$2"

if [[ "$output_path" != /* ]]; then
  output_path="$PWD/$output_path"
fi

if [[ ! -d "$app_path" || "${app_path##*.}" != "app" ]]; then
  echo "error: expected an existing .app bundle, got: $app_path" >&2
  exit 66
fi

package_root="$(mktemp -d)"
trap 'rm -rf "$package_root"' EXIT
mkdir -p "$package_root/Payload"
cp -R "$app_path" "$package_root/Payload/"
mkdir -p "$(dirname "$output_path")"
(
  cd "$package_root"
  /usr/bin/zip -qry "$output_path" Payload
)

echo "Created $output_path"
