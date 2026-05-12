# pequod-quarto

A Quarto extension applying the [Pequod palette](https://github.com/tiagojct/pequod)
— a pigment-inspired colour scheme rooted in *Moby-Dick*, with **Atkinson
Hyperlegible Next** for body and headings and **Atkinson Hyperlegible Mono**
for code. Ships three formats:

- `pequod-revealjs` — slides on warm paper
- `pequod-dark-revealjs` — slides on deep ink
- `pequod-html` — documents, reports, articles

Fonts are bundled (no Google Fonts CDN). Code highlighting maps each Pandoc
syntax token to a crew member: Ahab keywords, Tashtego strings, Pip numbers,
Ishmael comments, Starbuck functions, Queequeg types, Stubb constants,
Daggoo variables.

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

- **Palette** (the colour values in `_pequod-palette.scss`): CC-BY-4.0,
  © Tiago Jacinto. See `LICENSE-CC-BY-4.0`.
- **Code** (everything else in this extension): MIT, © Tiago Jacinto. See
  `LICENSE-MIT`.
- **Atkinson Hyperlegible Next & Mono**: SIL OFL 1.1, © Braille Institute
  of America. Distributed via Google Fonts.
