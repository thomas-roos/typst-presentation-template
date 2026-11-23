# Presentation

A slide deck in [Typst](https://typst.app) with [Touying](https://touying-typ.github.io).

## Edit

- `typst/deck.typ`: the deck, includes one file per section from `typst/slides/`.
- `typst/theme.typ`: the layouts, colours (`ink`, `accent`), fonts, event line and logo.
- `typst/slides/2-examples.typ`: one example of every layout. Delete what you don't need.

Open the repo in VS Code (or GitHub Codespaces) with the dev container: it has Typst,
LibreOffice and the Touying exporter, and the Tinymist extension previews `deck.typ` live.
Where the live preview does not work, the "Watch deck PDF" task rebuilds `typst/deck.pdf` on every save.

## Build

```sh
typst compile --font-path typst/fonts --ignore-system-fonts typst/deck.typ   # PDF only
typst/build.sh                                                              # all formats
```

`build.sh` makes `deck.pdf`, `deck.pdfpc` (speaker notes for [pdfpc](https://pdfpc.github.io)),
`deck.odp` (editable, with notes), `deck-images.odp` (one image per slide) and `deck.html`.

## CI

Every push to `typst/**` builds all formats in the same dev container and uploads them as
the `typst-deck` workflow artifact. The container image is cached in GHCR.

## Fonts

Plus Jakarta Sans and IBM Plex Mono, both under the SIL Open Font License (`typst/fonts/OFL-*.txt`).
