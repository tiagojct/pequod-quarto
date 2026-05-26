// Pequod institutional styling for Typst output.
//
// Mirrors the visual identity of pequod-html.scss / pequod.scss for the
// PDF/Typst format: warm-paper ground, deep-ink text, Starbuck-blue
// links with Starbuck underline, log-100 code blocks, log-400-bordered
// blockquotes, log-150 table header band with log-800 ink.
//
// Loaded via `include-in-header: [pequod-typst.typ]` in the typst
// format contribution of _extension.yml. Tokens are inlined (Typst has
// no upstream design-token import; keep these in sync with
// _extensions/pequod/_pequod-palette.scss).

// ---- Log scale ----
#let log-50  = rgb("#F7F3EE")
#let log-100 = rgb("#EAE1D7")
#let log-150 = rgb("#DBC9B6")
#let log-200 = rgb("#CFAD8E")
#let log-400 = rgb("#A16E50")
#let log-500 = rgb("#835A49")
#let log-700 = rgb("#163F54")
#let log-800 = rgb("#0D2F42")
#let log-900 = rgb("#0C222F")

// ---- Crew ----
#let ahab     = rgb("#A83732")
#let starbuck = rgb("#0082B1")
#let queequeg = rgb("#253E82")
#let pip      = rgb("#6A4A00")
#let ishmael  = rgb("#76716B")
#let stubb    = rgb("#CA6435")
#let tashtego = rgb("#177C55")
#let daggoo   = rgb("#552823")

#let pequod-text       = log-800
#let pequod-text-muted = log-500
#let pequod-bg         = log-50
#let pequod-surface    = log-100
#let pequod-border     = log-150
#let pequod-danger     = ahab

// ---- Body ----
#set par(justify: true, leading: 0.7em)
#set text(fill: pequod-text)

// ---- Headings ----
// H1 carries a thin Starbuck rule beneath the text. Echoes the HTML
// heading-color (log-700) for printed weight.
#show heading.where(level: 1): set block(below: 0.8em, above: 1.4em)
#show heading.where(level: 1): set text(size: 1.6em, weight: 700, fill: log-700)
#show heading.where(level: 1): it => block[
  #it
  #v(-0.45em)
  #line(length: 100%, stroke: 2pt + starbuck)
]

#show heading.where(level: 2): set text(weight: 700, fill: log-700)
#show heading.where(level: 3): set text(weight: 600, fill: log-700)

// ---- Links ----
// Dark link colour + Starbuck underline mirrors the HTML/reveal theme.
#show link: set text(fill: starbuck)
#show link: it => underline(stroke: 0.7pt + starbuck, offset: 2pt, it)

// ---- Inline code ----
// Daggoo on a log-100 paper tint, same as the HTML p > code rule.
#show raw.where(block: false): box.with(
  fill: pequod-surface,
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)
#show raw.where(block: false): set text(fill: daggoo)

// ---- Code blocks ----
#show raw.where(block: true): block.with(
  fill: pequod-surface,
  stroke: 1pt + pequod-border,
  inset: 10pt,
  radius: 4pt,
  width: 100%,
)

// ---- Block quote ----
#show quote.where(block: true): it => block(
  fill: pequod-surface,
  stroke: (left: 4pt + log-400),
  inset: (left: 12pt, rest: 10pt),
  radius: (right: 4pt),
  width: 100%,
  it.body,
)

// ---- Tables ----
// Header row: warm-paper-deep band (log-150 fill) with deep-ink text,
// matching the .table thead th rule in _pequod-html-rules.scss.
#show table.cell.where(y: 0): set text(fill: log-800, weight: 700)
#show table.cell.where(y: 0): set table.cell(fill: log-150)

// ---- Callouts ----
// Quarto's typst template generates `#callout(body: ..., title: ...,
// icon_color: ..., ...)` calls. The function signature has no
// callout-TYPE parameter, so we discriminate by the icon_color Quarto
// computed from Bootstrap defaults and remap to the Pequod crew. The
// mapping mirrors _pequod-html-rules.scss and the reveal callout block
// in _pequod-revealjs-rules.scss:
//   note → Starbuck   tip → Tashtego   warning → Stubb
//   caution → Pip     important → Ahab (danger)

#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  let pequod-border-paint = if icon_color == rgb("#0d6efd") { starbuck }
                            else if icon_color == rgb("#198754") { tashtego }
                            else if icon_color == rgb("#dc3545") { pequod-danger }
                            else if icon_color == rgb("#ffc107") { stubb }
                            else if icon_color == rgb("#fd7e14") { pip }
                            else { icon_color }

  let pequod-header-fill = if icon_color == rgb("#0d6efd") { rgb("#0082B11F") }
                           else if icon_color == rgb("#198754") { rgb("#177C551F") }
                           else if icon_color == rgb("#dc3545") { rgb("#A837321A") }
                           else if icon_color == rgb("#ffc107") { rgb("#CA64351F") }
                           else if icon_color == rgb("#fd7e14") { rgb("#6A4A0026") }
                           else { pequod-surface }

  block(
    breakable: false,
    fill: pequod-bg,
    stroke: (
      left: 4pt + pequod-border-paint,
      rest: 0.5pt + pequod-border,
    ),
    width: 100%,
    radius: 2pt,
    inset: 0pt,
    block(
      width: 100%,
      fill: pequod-header-fill,
      inset: 8pt,
      below: 0pt,
    )[
      #if icon != none [#text(pequod-border-paint, weight: 900)[#icon] ]
      #text(weight: 700)[#title]
    ]
    + if body != [] {
      block(
        inset: 8pt,
        width: 100%,
        fill: pequod-bg,
        body,
      )
    }
  )
}
