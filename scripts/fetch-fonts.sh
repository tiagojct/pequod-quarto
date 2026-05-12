#!/usr/bin/env bash
# Fetch Atkinson Hyperlegible Next & Mono woff2 from Google Fonts and stage
# them in _extensions/pequod/fonts/. Re-run when bumping font versions.
set -euo pipefail

cd "$(dirname "$0")/.."
FONTS_DIR=_extensions/pequod/fonts
mkdir -p "$FONTS_DIR"

UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
CSS_URL='https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible+Next:ital,wght@0,400;0,600;0,700;1,400&family=Atkinson+Hyperlegible+Mono:wght@400;600&display=swap'

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
curl -fsSL -A "$UA" "$CSS_URL" -o "$TMP"

python3 - "$TMP" "$FONTS_DIR" <<'PY'
import re, sys, urllib.request, pathlib

css_path, out_dir = sys.argv[1], pathlib.Path(sys.argv[2])
css = open(css_path).read()
UA = ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

# Split into entries separated by /* comment */; the preceding comment tells
# us the subset (latin / latin-ext).
entries = re.split(r'/\*\s*([\w-]+)\s*\*/', css)
# entries = ['', 'latin-ext', '...@font-face{...}...', 'latin', '...', ...]

faces = []
for i in range(1, len(entries) - 1, 2):
    subset = entries[i]
    block_text = entries[i + 1]
    fam = re.search(r"font-family:\s*'([^']+)'", block_text)
    sty = re.search(r"font-style:\s*([^;]+);", block_text)
    url = re.search(r"url\((https://[^)]+\.woff2)\)", block_text)
    if not (fam and url):
        continue
    family = fam.group(1)
    style  = (sty.group(1).strip() if sty else 'normal')
    faces.append((family, style, subset, url.group(1)))

seen = {}
for fam, sty, sub, src in faces:
    fam_slug   = fam.replace(' ', '')
    axis       = 'Italic' if sty == 'italic' else 'Variable'
    target_name = f'{fam_slug}-{axis}-{sub}.woff2'
    if src in seen:
        continue
    target = out_dir / target_name
    req = urllib.request.Request(src, headers={'User-Agent': UA})
    with urllib.request.urlopen(req) as r:
        target.write_bytes(r.read())
    print(f'  {target_name}  ({target.stat().st_size} bytes)')
    seen[src] = target_name

print(f'{len(seen)} unique woff2 files in {out_dir}')
PY

echo
echo "Next: scripts/build-fonts.sh"
