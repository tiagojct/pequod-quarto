# Contributing to pequod-quarto

Thanks for considering a contribution. This document covers the branch /
commit / release flow and the small set of design rules that keep the
four output formats coherent.

## Local development

```sh
# clone
git clone https://github.com/tiagojct/pequod-quarto.git
cd pequod-quarto

# render the four examples
quarto render example.qmd          # pequod-revealjs (light)
quarto render example-dark.qmd     # pequod-dark-revealjs
quarto render example-html.qmd     # pequod-html (light + dark via toggle)
quarto render example-typst.qmd    # pequod-typst PDF
```

The extension consumes itself via the in-source `_extensions/` directory.
There is no install step; edit the SCSS / Lua / Typst sources directly
and re-render the example to see the change.

## Repository layout

```
_extensions/
├── pequod/                          # primary extension (light + html + typst)
│   ├── _extension.yml
│   ├── pequod-variables.scss        # design tokens (light) — theme entry
│   ├── pequod-variables-dark.scss   # design tokens (dark)   — theme entry
│   ├── _pequod-fonts.scss           # @font-face with base64 woff2
│   ├── _pequod-revealjs-rules.scss  # shared reveal rules (light + dark)
│   ├── _pequod-html-rules.scss      # shared html rules (light + dark)
│   ├── pequod.scss                  # revealjs rules entry (rules-only)
│   ├── pequod-html.scss             # html rules entry (rules-only)
│   ├── pequod-typst.typ             # typst format include
│   ├── pequod.lua                   # logo + OG/Twitter meta filter
│   ├── pequod.theme                 # Pandoc highlight (light)
│   ├── pequod-dark.theme            # Pandoc highlight (dark)
│   └── fonts/                       # source woff2 + static-weight TTFs
└── pequod-dark/                     # dark reveal variant (shares partials)
    ├── _extension.yml
    ├── pequod-dark.scss             # reveal-dark rules entry (rules-only)
    ├── pequod-variables-dark.scss   # design tokens (dark)
    └── pequod-dark.theme
```

## Design rules

### 1. Tokens live in `pequod-variables.scss` / `pequod-variables-dark.scss`. Nothing else owns colour.

The crew aliases (`$ahab`, `$starbuck`, …), the log scale
(`$log-50` → `$log-950`), the surface tokens (`$body-bg`,
`$surface`, …), the data-viz palette (`$pequod-chart-1..8`), the
highlight pill, the radius tokens — all live in the variables files
and all carry `!default` so consumers can override.

Two variants ship side by side: `pequod-variables.scss` (light) and
`pequod-variables-dark.scss` (dark). Both declare the SAME active
alias names; only the values differ. Rules files
(`_pequod-revealjs-rules.scss`, `_pequod-html-rules.scss`) reference
only those active aliases — never a `-light` or `-dark` suffix —
so the same rules file works for both variants.

The variables files are listed as **separate theme entries** in
`_extension.yml`, not as `@import` partials inside the rules files.
Quarto's deno-sass binding emits spurious "variable used before
declaration" warnings whenever a partial gets re-imported across
stacked theme entries; keeping tokens at the entry level sidesteps
the warning. Mirror of `quarto-fmup`'s pattern.

### 2. The reveal SCSS is paint-only.

Colour, fonts, small typographic details only. Do NOT override
`display`, `position`, `height`, or visibility on `#title-slide` or
`section.center` — reveal owns layout. Vertical centring is reveal's
`center: true`, not CSS.

The single allowed exception is `:has()`-based footer / logo hiding
on title slides and `.no-footer` / `.no-logo` opt-outs, because the
footer lives outside the per-slide section tree at the `.reveal`
level and there is no other reliable hook.

### 3. The crew is the colour grammar.

Syntax classes, callouts, chart slots, and any new accent surface
must pick from the crew (`$ahab`, `$starbuck`, `$queequeg`, `$pip`,
`$ishmael`, `$stubb`, `$tashtego`, `$daggoo`) so all four formats
share the same colour palette. Red is reserved for `$danger`
(callout-important, errors).

### 4. The four formats stay in lock-step.

A token added to `_pequod-palette.scss` should be wired into
`_pequod-revealjs-rules.scss`, `_pequod-html-rules.scss`, AND
`pequod-typst.typ` (Typst has no design-token import; hex values are
inlined in `pequod-typst.typ` and kept in sync by hand). Syntax
highlighting (`pequod.theme` / `pequod-dark.theme`) must follow the
same crew → role mapping.

### 5. Accessibility is non-negotiable.

- Two-channel link distinction (colour + underline + weight).
- `:focus-visible` outline must be body-colour, not brand colour
  (brand colour alone often fails WCAG 1.4.11 contrast).
- All callout / link / accent surfaces must hold ≥4.5:1 contrast
  against their background in both light and dark modes. The
  ink-on-anchor constants exist precisely so anchor surfaces that
  don't flip across modes carry the right ink.
- `prefers-reduced-motion: reduce` clamp on both HTML and reveal.
- Print stylesheet that hides chrome and expands external URLs.

## Commit + release flow

Branches:

- `main` — release branch. Tagged releases ship from here.
- feature branches — `feat/`, `fix/`, `docs/`, `chore/` prefixes.

Commits: one logical change per commit. Subject line ≤ 72 chars,
imperative mood. Body wraps at 72.

Release:

1. Update `version:` in BOTH `_extensions/pequod/_extension.yml` and
   `_extensions/pequod-dark/_extension.yml` — keep them in sync.
2. Add a `## [x.y.z] - YYYY-MM-DD` section to `CHANGELOG.md`
   covering everything since the previous tag.
3. Commit with subject `Release vX.Y.Z`.
4. Tag with `git tag vX.Y.Z -m "Release vX.Y.Z"`.
5. Push tag with `git push origin vX.Y.Z`.

Consumers update with `quarto update tiagojct/pequod-quarto`.

## Licence

By contributing you agree your contribution is dual-licensed under
the same terms as the rest of the repo: colour values CC-BY-4.0,
everything else MIT.
