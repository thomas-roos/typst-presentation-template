#!/usr/bin/env python3
"""Finish the ODP that LibreOffice's PDF import made from deck.pdf.

    python3 fix_odp.py deck.odp deck.pdfpc

- puts the speaker notes back (a PDF has none): deck.pdfpc is the output of
  `typst eval 'query(<pdfpc-file>).first().value' --in deck.typ`
- renames the font faces from their PostScript names in the PDF
  ("PlusJakartaSans") to the family names, so Impress finds the installed fonts.
"""
import json
import sys
import zipfile
from xml.sax.saxutils import escape

# LibreOffice's import gives every page an empty notes placeholder
FONTS = {"PlusJakartaSans": "Plus Jakarta Sans", "IBMPlexMono": "IBM Plex Mono"}
EMPTY = 'presentation:class="notes" presentation:placeholder="true"><draw:text-box/>'


def fix(content, notes):
    for ps, family in FONTS.items():
        content = content.replace(f'svg:font-family="{ps}"', f"svg:font-family=\"'{family}'\"")
    pages = content.split("</draw:page>")
    for i, note in notes.items():
        paras = "".join(f"<text:p>{escape(line)}</text:p>" for line in note.split("\n"))
        pages[i] = pages[i].replace(EMPTY, f'presentation:class="notes"><draw:text-box>{paras}</draw:text-box>')
    return "</draw:page>".join(pages)


def main(odp, notes_json):
    pdfpc = json.load(open(notes_json))
    # pdfpc idx counts PDF pages, one per ODP page
    notes = {p["idx"]: p["note"] for p in pdfpc["pages"] if p.get("note")}
    with zipfile.ZipFile(odp) as z:
        files = {i: z.read(i) for i in z.infolist()}
    with zipfile.ZipFile(odp, "w", zipfile.ZIP_DEFLATED) as z:
        for info, data in files.items():  # mimetype stays first and stored
            if info.filename == "content.xml":
                data = fix(data.decode(), notes).encode()
            z.writestr(info, data)


if __name__ == "__main__":
    page = f"<draw:page><x {EMPTY}</draw:frame></draw:page>"
    out = fix(page * 2, {1: "a & b\nc"})
    assert out.startswith(page), out
    assert out.endswith('presentation:class="notes"><draw:text-box><text:p>a &amp; b</text:p>'
                        "<text:p>c</text:p></draw:text-box></draw:frame></draw:page>"), out
    main(*sys.argv[1:])
