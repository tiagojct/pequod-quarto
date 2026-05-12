# pequod-quarto

A Quarto extension that applies the [Pequod palette](https://github.com/tiagojct/pequod)
to slide decks and documents. Body and headings render in Atkinson
Hyperlegible Next; code renders in Atkinson Hyperlegible Mono. Both fonts
are bundled inside the theme (no Google Fonts CDN at render time).

The extension contributes three formats:

| Format | Use for | Surface |
|---|---|---|
| `pequod-revealjs` | Slide decks | Warm paper |
| `pequod-dark-revealjs` | Slide decks | Deep ink |
| `pequod-html` | Documents, reports, articles | Warm paper |

Pandoc syntax classes map to the crew: keyword → Ahab, string → Tashtego,
number → Pip, comment → Ishmael, function → Starbuck, type → Queequeg,
constant → Stubb, variable → Daggoo. The mapping is identical across the
revealjs and html formats, so syntax highlighting in a slide matches syntax
highlighting in a report.

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

Dark variant:

```yaml
format: pequod-dark-revealjs
```

HTML document:

```yaml
format: pequod-html
```

## What ships

```
_extensions/
├── pequod/
│   ├── _extension.yml
│   ├── pequod.scss              # revealjs entry (light)
│   ├── pequod-html.scss         # html entry
│   ├── pequod.theme             # Pandoc highlight (light)
│   ├── _pequod-palette.scss     # shared design tokens
│   ├── _pequod-fonts.scss       # @font-face (base64 woff2)
│   ├── _pequod-revealjs-rules.scss   # shared reveal rules
│   └── fonts/                   # source woff2 (kept for rebuilds)
├── pequod-dark/
│   ├── _extension.yml
│   ├── pequod-dark.scss
│   └── pequod-dark.theme
└── ...
template.qmd                     # consumed by `quarto use template`
```

The two extensions share `_pequod-palette.scss`, `_pequod-fonts.scss`, and
`_pequod-revealjs-rules.scss` via Sass `@import "../pequod/…"`.

## Customising

Every token in `_pequod-palette.scss` is declared with `!default`. Override
them in your own qmd before the extension theme loads by composing a theme
array:

```yaml
format:
  pequod-revealjs:
    theme:
      - my-overrides.scss   # set $log-50, $starbuck-light, …
```

## Licence

The colour values in `_pequod-palette.scss` are licensed CC-BY-4.0 (see
`LICENSE-CC-BY-4.0`); everything else in this extension (SCSS rules,
Pandoc themes, extension manifests, documentation) is MIT (see
`LICENSE-MIT`). Both © Tiago Jacinto.

Atkinson Hyperlegible Next and Mono are © Braille Institute of America,
distributed under SIL OFL 1.1 via Google Fonts.
