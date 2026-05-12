#!/usr/bin/env bash
# Regenerate _extensions/pequod/_pequod-fonts.scss from the woff2 files in
# _extensions/pequod/fonts/. Re-run when font files are refreshed.
set -euo pipefail

cd "$(dirname "$0")/.."
FONTS_DIR=_extensions/pequod/fonts
OUT=_extensions/pequod/_pequod-fonts.scss

if [ ! -d "$FONTS_DIR" ]; then
  echo "missing $FONTS_DIR — run scripts/fetch-fonts.sh first" >&2
  exit 1
fi

cd "$FONTS_DIR"

LATIN_EXT_RANGE='U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF'
LATIN_RANGE='U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD'

emit_face() {
  local family="$1" style="$2" weight="$3" file="$4" range="$5"
  cat <<EOF
@font-face {
  font-family: "$family";
  font-style: $style;
  font-weight: $weight;
  font-display: swap;
  src: url("data:font/woff2;base64,$(base64 -i "$file")") format("woff2");
  unicode-range: $range;
}
EOF
}

{
  cat <<'HEADER'
// =============================================================================
// Pequod — local @font-face declarations (base64-embedded)
// Atkinson Hyperlegible Next & Mono — SIL OFL 1.1 (Braille Institute).
// Variable-weight WOFF2 inlined as data URIs (Quarto's revealjs compile
// pipeline does not copy extension /fonts/ dirs into the output tree, so
// embedding side-steps path resolution entirely; ~150KB total).
// To regenerate: ../scripts/build-fonts.sh
// =============================================================================

// ---- Atkinson Hyperlegible Next --------------------------------------------
HEADER

  emit_face "Atkinson Hyperlegible Next" "normal" "400 700" "AtkinsonHyperlegibleNext-Variable-latin-ext.woff2" "$LATIN_EXT_RANGE"
  emit_face "Atkinson Hyperlegible Next" "normal" "400 700" "AtkinsonHyperlegibleNext-Variable-latin.woff2"     "$LATIN_RANGE"
  emit_face "Atkinson Hyperlegible Next" "italic" "400"     "AtkinsonHyperlegibleNext-Italic-latin-ext.woff2"   "$LATIN_EXT_RANGE"
  emit_face "Atkinson Hyperlegible Next" "italic" "400"     "AtkinsonHyperlegibleNext-Italic-latin.woff2"       "$LATIN_RANGE"

  echo
  echo "// ---- Atkinson Hyperlegible Mono --------------------------------------------"

  emit_face "Atkinson Hyperlegible Mono" "normal" "400 700" "AtkinsonHyperlegibleMono-Variable-latin-ext.woff2" "$LATIN_EXT_RANGE"
  emit_face "Atkinson Hyperlegible Mono" "normal" "400 700" "AtkinsonHyperlegibleMono-Variable-latin.woff2"     "$LATIN_RANGE"
} > ../../../"$OUT"

echo "wrote $OUT ($(wc -c <../../../"$OUT") bytes)"
