#!/bin/sh
# Build deck.pdf, deck.pdfpc (speaker notes for pdfpc), deck.odp (editable),
# deck-images.odp (one image per slide) and deck.html (offline browser deck).
set -e
cd "$(dirname "$0")"
FONTS="--font-path fonts"
typst compile $FONTS --ignore-system-fonts deck.typ deck.pdf
soffice --headless --infilter=impress_pdf_import --convert-to odp deck.pdf
typst eval 'query(<pdfpc-file>).first().value' --in deck.typ $FONTS > deck.pdfpc
python3 fix_odp.py deck.odp deck.pdfpc
touying compile --format pptx --font-paths fonts --ppi 250 --output deck-images.pptx deck.typ
soffice --headless --convert-to odp deck-images.pptx
touying compile --format html --font-paths fonts --output deck.html deck.typ
