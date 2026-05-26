# Changelog

All notable changes to `pequod-quarto` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-05-26

### Added

**Format coverage**

- **`pequod-typst` PDF format.** New `pequod-typst.typ` mirrors the
  visual identity of the HTML / reveal formats: warm-paper ground,
  deep-ink text, Starbuck-blue links with Starbuck underline, log-100
  code blocks, log-400-bordered blockquotes, log-150 table header
  band with log-800 ink. A `#callout` override maps Quarto/Bootstrap
  default colours to the crew (note → Starbuck, tip → Tashtego,
  warning → Stubb, caution → Pip, important → Ahab). Static-weight
  TTFs for Atkinson Hyperlegible Next + Mono (Regular / Italic /
  Bold / BoldItalic) bundled under `_extensions/pequod/fonts/` so
  Typst loads them directly (variable woff2 is not supported by
  Typst ≤ 0.14). `font-paths` is set relative to the extension dir
  so the canonical org-prefixed Quarto install
  (`_extensions/tiagojct/pequod/fonts`) resolves correctly.
- **`pequod-html` dark mode** via Quarto's `theme: { light, dark }`
  contract. New `pequod-html-dark.scss` mirrors the light variant
  with the deep-ink palette and sets `$enable-dark-mode: true` so
  Bootstrap 5.3 emits its `[data-bs-theme="dark"]` component tokens.
  Pandoc highlighting follows via
  `highlight-style: { light: pequod.theme, dark: pequod-dark.theme }`.

**Tokens + data-viz palette**

- **Eight categorical chart colours** (`$pequod-chart-1..8-light` /
  `…-dark`) drawn from the crew, exported as `--pequod-chart-1..8`
  CSS custom properties on `:root` so Observable / htmlwidgets / JS
  pick them up at runtime via `getComputedStyle(...).getPropertyValue`.
  Hex literals inlined (not aliased to crew tokens) to avoid Sass
  "variable used before declaration" noise when the palette is
  re-imported across stacked theme entries in Quarto's defaults
  cascade.
- **`$danger-light` / `$danger-dark`** tokens for the reserved
  "stop" signal. Light tracks Ahab; dark lightens to `#F47A6E` so
  contrast holds ≥4.5:1 against the deep-ink surface. Callout-important
  switches to `$danger` in both reveal and HTML.
- **`$highlight-bg` / `$highlight-color`** tokens for the slide-level
  `<mark>` / `.highlight` pill. Pinned per-mode (warm-paper-deep in
  light, deep-paper-light in dark).
- **`$ink-on-paper` / `$ink-on-ink`** constants for surfaces whose
  background does NOT flip across modes.
- **`$pequod-radius` / `$pequod-radius-sm`** unified radius tokens.

**Reveal niceties**

- **`:has()`-based hide-footer + hide-logo** on the deck title slide
  and H1 section dividers. Per-slide opt-out via
  `## My slide {.no-footer .no-logo}`. Requires Chrome 105+ /
  Firefox 121+ / Safari 15.4+ (reveal already targets these).
- **`.highlight` / `<mark>` pill** styled with the highlight tokens.
- **`.columns` flex helper** so the standard
  `::: {.columns} ::: {.column} … ::: :::` Quarto markdown lays out
  cleanly on slides.
- **`:focus-visible`** body-colour outline + Starbuck box-shadow
  glow so the focus cue is WCAG 1.4.11-compliant (yellow alone on
  paper would fail) while keeping the brand cue.

**HTML niceties**

- **Print stylesheet.** Hides navbar / sidebar / TOC / footer,
  prints `(href)` after external links so paper readers can follow,
  strips surface fills, prevents page breaks inside headings /
  figures / tables.
- **`prefers-reduced-motion: reduce` clamp** for both HTML and
  reveal output (HTML disables theme smooth-scroll; reveal clamps
  callout / fragment animation durations to 0.01ms).
- **Prose-link two-channel cue** (Starbuck colour + 2px underline +
  weight 500), scoped to `main` / `article` / `.content` so
  navbar / sidebar / TOC / footer / repo-action links keep their
  own treatments.
- **`code-copy: true`**, **`code-overflow: wrap`**,
  **`smooth-scroll: true`**, **`anchor-sections: true`**,
  **`link-external-newwindow: true`** turned on by default for the
  `pequod-html` format.

**Lua filter (`pequod.lua`)**

- Forwards `pequod.logo` from project YAML to format-specific keys
  (`logo` for revealjs, `website.navbar.logo` for sites,
  `book.navbar.logo` for books). Non-destructive of user-set values.
- Emits Open Graph + Twitter Card `<meta>` tags from each page's
  `title`, `description`, `lang`, `author`. Resolves `og:image`
  from `pequod.og-image`, `website.open-graph.image`, or per-page
  `og-image` (in that order). Twitter card upgrades to
  `summary_large_image` when an image is set; falls back to plain
  `summary` otherwise.

**Process**

- `CHANGELOG.md` (this file) added.
- `CONTRIBUTING.md` with branch / commit / release flow and the
  design rules.
- CI: `render-examples.yml` matrix-renders all four example projects
  on push / PR.

### Changed

- Extension version bumped to `0.3.0` (additive minor release).
- Reveal callouts: `caution` switches from Ahab (red) to Pip (warm
  dark yellow) so the red is reserved for `important` alone.
- HTML rules extracted to `_pequod-html-rules.scss` partial so the
  light and dark entries share the same body, only the tokens vary.

### Fixed

- Sass "variable used before declaration" noise narrowed by
  inlining hex literals on derived tokens
  (`$pequod-chart-N-light/dark`, `$danger-light/dark`). The
  remaining warnings come from Quarto's defaults-cascade pipeline
  running `!default` chains across stacked theme files and are
  cosmetic — compilation succeeds and output is correct.

## [0.2.0] - initial release

- `pequod-revealjs`, `pequod-dark-revealjs`, `pequod-html` formats.
- Self-hosted Atkinson Hyperlegible Next + Mono (variable woff2,
  base64-inlined via `_pequod-fonts.scss`).
- Pandoc highlight themes (light + dark) with the crew → syntax
  mapping (keyword → Ahab, string → Tashtego, number → Pip,
  comment → Ishmael, function → Starbuck, type → Queequeg,
  constant → Stubb, variable → Daggoo).

[0.3.0]: https://github.com/tiagojct/pequod-quarto/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/tiagojct/pequod-quarto/releases/tag/v0.2.0
