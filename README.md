# pequod-quarto

A Quarto extension that applies the [Pequod palette](https://github.com/tiagojct/pequod)
to slide decks, documents, and PDFs. Body and headings render in Atkinson
Hyperlegible Next; code renders in Atkinson Hyperlegible Mono. Both fonts
are bundled inside the theme (no Google Fonts CDN at render time).

The extension contributes four formats:

| Format | Use for | Surface |
|---|---|---|
| `pequod-revealjs` | Slide decks | Warm paper (light + dark via `pequod-dark-revealjs`) |
| `pequod-dark-revealjs` | Slide decks | Deep ink |
| `pequod-html` | Documents, reports, articles | Warm paper, dark variant via `data-bs-theme` |
| `pequod-typst` | PDF output | Warm paper |

Pandoc syntax classes map to the crew: keyword → Ahab, string → Tashtego,
number → Pip, comment → Ishmael, function → Starbuck, type → Queequeg,
constant → Stubb, variable → Daggoo. The mapping is identical across the
revealjs, html, and typst formats, so syntax highlighting in a slide
matches syntax highlighting in a report.

## Install

From a Quarto project:

```sh
quarto add tiagojct/pequod-quarto
```

Or scaffold a new deck from the template:

```sh
quarto use template tiagojct/pequod-quarto
```

## Use

```yaml
---
title: "Your title"
format: pequod-revealjs
---
```

Dark reveal variant:

```yaml
format: pequod-dark-revealjs
```

HTML document (light + dark, user can toggle via the navbar when
`theme-toggle: true`):

```yaml
format: pequod-html
```

PDF via Typst:

```yaml
format: pequod-typst
```

## What ships

```
_extensions/
├── pequod/
│   ├── _extension.yml
│   ├── pequod.scss                    # revealjs entry (light)
│   ├── pequod-html.scss               # html entry (light)
│   ├── pequod-html-dark.scss          # html entry (dark)
│   ├── pequod-typst.typ               # typst format
│   ├── pequod.lua                     # logo + OG/Twitter meta filter
│   ├── pequod.theme                   # Pandoc highlight (light)
│   ├── pequod-dark.theme              # Pandoc highlight (dark)
│   ├── _pequod-palette.scss           # shared design tokens
│   ├── _pequod-fonts.scss             # @font-face (base64 woff2)
│   ├── _pequod-revealjs-rules.scss    # shared reveal rules
│   ├── _pequod-html-rules.scss        # shared html rules
│   └── fonts/                         # source woff2 + static TTFs (Typst)
└── pequod-dark/
    ├── _extension.yml
    ├── pequod-dark.scss
    └── pequod-dark.theme
template.qmd                           # consumed by `quarto use template`
```

The two extensions share `_pequod-palette.scss`, `_pequod-fonts.scss`,
`_pequod-revealjs-rules.scss`, and `pequod.lua` via Sass `@import
"../pequod/…"` and a relative-path Lua filter reference.

## Data-viz palette

Eight categorical chart colours are exported as CSS custom properties on
`:root`:

```
--pequod-chart-1  log-800 / log-100   (deep ink ↔ warm paper)
--pequod-chart-2  starbuck            (blue)
--pequod-chart-3  ahab                (red)
--pequod-chart-4  tashtego            (green)
--pequod-chart-5  stubb               (orange)
--pequod-chart-6  queequeg            (indigo)
--pequod-chart-7  pip                 (warm dark yellow)
--pequod-chart-8  daggoo              (brown)
```

Observable / htmlwidgets / plain JS can pick them up at runtime:

```js
getComputedStyle(document.documentElement).getPropertyValue('--pequod-chart-2')
```

## Logo and social meta

`pequod.lua` forwards a single `pequod.logo` setting to the right
format-specific keys (reveal `logo`, website/book navbar `logo`) and
emits Open Graph + Twitter Card `<meta>` tags from each page's
frontmatter. Set once in `_quarto.yml`:

```yaml
pequod:
  logo: assets/logo.svg
  og-image: assets/og-card.png
```

## Customising

Every token in `_pequod-palette.scss` is declared with `!default`.
Override them in your own qmd before the extension theme loads by
composing a theme array:

```yaml
format:
  pequod-revealjs:
    theme:
      - my-overrides.scss   # set $log-50, $starbuck-light, …
      - default
```

## Licence

The colour values in `_pequod-palette.scss` are licensed CC-BY-4.0 (see
`LICENSE-CC-BY-4.0`); everything else in this extension (SCSS rules,
Pandoc themes, Typst include, Lua filter, extension manifests,
documentation) is MIT (see `LICENSE-MIT`). Both © Tiago Jacinto.

Atkinson Hyperlegible Next and Mono are © Braille Institute of America,
distributed under SIL OFL 1.1 via Google Fonts.
