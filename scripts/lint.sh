#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

while IFS= read -r -d '' script; do
  bash -n "$script"
done < <(find scripts -type f -name '*.sh' -print0)

while IFS= read -r -d '' json; do
  python3 -m json.tool "$json" >/dev/null
done < <(find Resources WebResources -type f -name '*.json' -print0)

while IFS= read -r -d '' plist; do
  if command -v plutil >/dev/null 2>&1; then
    plutil -lint "$plist" >/dev/null
  else
    python3 -c 'import plistlib,sys; plistlib.load(open(sys.argv[1], "rb"))' "$plist"
  fi
done < <(find Resources Entitlements -type f \( -name '*.plist' -o -name '*.entitlements' \) -print0)

if command -v node >/dev/null 2>&1; then
  while IFS= read -r -d '' script; do
    node --check "$script" >/dev/null
  done < <(find WebResources -type f -name '*.js' -print0)
else
  echo "warning: Node.js unavailable; JavaScript syntax validation skipped" >&2
fi

if command -v ruby >/dev/null 2>&1; then
  ruby -e 'require "yaml"; ARGV.each { |path| YAML.load_file(path) }' \
    project.yml .github/workflows/*.yml
else
  echo "warning: Ruby unavailable; YAML parse validation skipped" >&2
fi

python3 - <<'PY'
import pathlib
import sys

root = pathlib.Path('.')
required = [
    root / 'project.yml',
    root / 'NBlocker/App/NBlockerApp.swift',
    root / 'NBlocker/Web/Rules/RuleEngine.swift',
    root / 'WebResources/Shared/bootstrap.js',
]
empty = [str(path) for path in required if not path.exists() or path.stat().st_size == 0]
if empty:
    print('error: required files are missing or empty:', *empty, sep='\n  ', file=sys.stderr)
    sys.exit(1)

for catalog in (root / 'Resources/Assets.xcassets').rglob('Contents.json'):
    import json
    value = json.loads(catalog.read_text(encoding='utf-8'))
    for image in value.get('images', []):
        filename = image.get('filename')
        if filename and not (catalog.parent / filename).is_file():
            print(f'error: {catalog} references missing asset {filename}', file=sys.stderr)
            sys.exit(1)
PY

echo "Repository lint passed."
