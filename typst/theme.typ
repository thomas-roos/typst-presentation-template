// Slide layouts on a 16:9 page (25.4 × 14.287 cm). Every part is placed at a
// fixed position in cm with at(), so slides look the same in every export.
// Change the look here: colours, fonts, event line, logo.
#import "@preview/touying:0.8.0": *

#let ink = rgb("#111111")
#let accent = rgb("#3b6ef5")
#let muted = luma(235)
#let sans = "Plus Jakarta Sans"
#let mono = "IBM Plex Mono"
#let event = "Event name · Venue · Date"  // top right on content slides
#let logo = none  // e.g. image("assets/logo.svg", width: 2.5cm), top left on content slides

#let at(x, y, w: none, h: none, body) = place(top + left, dx: x * 1cm, dy: y * 1cm,
  box(width: if w == none { auto } else { w * 1cm }, height: if h == none { auto } else { h * 1cm }, body))

// Text: size in pt, line height in % of the font's line, a blank line between paragraphs.
#let txt(size, weight: "light", font: sans, fill: ink, lh: 100%, body) = {
  let line = if font == mono { 1.3em } else { 1.26em }
  let leading = (lh / 100% - 1) * line
  set text(font: font, size: size * 1pt, weight: weight, fill: fill, top-edge: "ascender", bottom-edge: "descender")
  set par(leading: leading, spacing: leading + lh / 100% * line)
  show strong: set text(weight: "medium")
  body
}
#let caps(size, fill: accent, lh: 100%, body) = txt(size, weight: "regular", font: mono, fill: fill, lh: lh, upper(body))
#let title(body) = at(1.323, 2.54, w: 22.5, txt(22.8, weight: "regular", body))

#let header() = {
  if logo != none { at(0.992, 1.0, logo) }
  at(17.286, 0.595, w: 7.346, align(right, txt(5.4, weight: "regular", event)))
}
#let footer() = at(22.777, 13.11, w: 2, align(right, txt(7.2, weight: "regular", context str(here().page()))))
#let fill-bg(color) = place(rect(width: 100%, height: 100%, fill: color))

// One slide: background, then the parts, then the speaker note.
#let slide-page(bg: none, note: none, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-page(margin: 0pt))
  touying-slide(self: self, {
    if bg != none { bg }
    body
    if note != none { speaker-note(note) }
  })
})

// Title: big heading, caps subtitle, accent bar on the left.
#let title-slide(heading, subtitle, note: none) = slide-page(note: note, {
  at(0, 0, rect(width: 0.5cm, height: 14.287cm, fill: accent))
  if logo != none { at(1.654, 1.6, logo) }
  at(1.654, 4.5, w: 22.5, h: 6.8, align(bottom, txt(54, heading)))
  at(1.654, 12.158, w: 20, caps(10.7, fill: ink, subtitle))
})

// Section divider: accent background, big white title, number bottom right.
#let divider(n, heading, note: none) = slide-page(note: note, bg: fill-bg(accent), {
  at(1.323, 7.8, w: 20, h: 5.5, align(bottom, txt(64.2, fill: white, lh: 89%, heading)))
  if n != none { at(20.957, 11.39, w: 3, align(right, txt(53.5, fill: white, [#n.]))) }
})

// Big heading left, body right.
#let heading-slide(heading, body, note: none) = slide-page(note: note, {
  header(); footer()
  at(1.68, 3.956, w: 10.5, txt(35.7, lh: 89%, heading))
  at(12.859, 3.956, w: 11.799, txt(10.4, body))
})

// One statement, large.
#let statement(body, note: none) = slide-page(note: note, {
  header(); footer()
  at(1.323, 5.2, w: 22.5, txt(35.7, body))
})

// Title, body, caps label, big question on a grey band.
#let question-slide(heading, body, label, question, note: none) = slide-page(note: note, {
  at(0, 7.4, rect(width: 25.4cm, height: 6.887cm, fill: muted))
  header(); footer()
  at(1.323, 2.738, w: 22.5, txt(26.7, weight: "medium", heading))
  at(1.323, 4.101, w: 21, txt(12.9, body))
  at(1.323, 7.924, caps(7.9, fill: ink, label))
  at(1.323, 8.387, w: 22.5, txt(26.7, weight: "medium", question))
})

// Title, body, caps label, result. Code in ``` blocks is set in mono.
#let result-slide(heading, body, label, result, note: none) = slide-page(note: note, {
  header(); footer()
  show raw: set text(font: mono, size: 10.5pt)
  set raw(theme: none)
  title(heading)
  at(1.323, 3.836, w: 22.753, txt(12.5, lh: 115%, body))
  if label != none { at(1.323, 8.718, caps(10, lh: 139%, label)) }
  if result != none { at(1.323, 9.499, w: 22.5, txt(14.3, lh: 115%, result)) }
})

// Text left, two cards. A card is (label, title, body).
#let cards-slide(heading, subtitle, left, card1, card2, note: none) = slide-page(note: note, {
  header(); footer()
  title(heading)
  at(1.323, 3.836, w: 15, txt(12.5, subtitle))
  at(1.323, 6.337, w: 6.4, txt(9.3, left))
  for (x, c) in ((8.9, card1), (16.6, card2)) {
    let (label, name, body) = c
    at(x, 4.6, rect(width: 7.4cm, height: 8cm, radius: 0.25cm, fill: muted))
    at(x + 0.5, 5.0, caps(6.1, label))
    at(x + 0.5, 5.5, w: 6.4, txt(16.1, weight: "regular", name))
    at(x + 0.5, 6.5, w: 6.4, txt(8.6, body))
  }
})

// Up to five steps left to right. A step is (label, body).
#let flow-slide(heading, subtitle, steps, below: none, note: none) = slide-page(note: note, {
  header(); footer()
  title(heading)
  at(1.323, 3.929, w: 22, txt(11.4, subtitle))
  let w = 22.75 / steps.len()
  for (i, (label, body)) in steps.enumerate() {
    let x = 1.323 + i * w
    at(x, 5.2, rect(width: (w - 0.3) * 1cm, height: 0.12cm, fill: accent))
    at(x, 5.6, caps(7.9, fill: accent)[0#(i + 1)])
    at(x, 6.2, w: w - 0.5, txt(10.7, weight: "bold", label))
    at(x, 7.0, w: w - 0.5, txt(7.9, weight: "regular", body))
  }
  if below != none { at(1.323, 10.0, w: 22, txt(11.4, below)) }
})

// Up to four stacked boxes, one or two lines each.
#let boxes-slide(heading, items, note: none) = slide-page(note: note, {
  header(); footer()
  title(heading)
  for (body, y) in items.zip((4.0, 6.3, 8.6, 10.9)) {
    at(1.323, y, rect(width: 22.75cm, height: 2cm, radius: 0.2cm, fill: muted))
    at(2.0, y, w: 21.4, h: 2, align(horizon, txt(12.9, lh: 119%, body)))
  }
})

// 2×2 numbered grid. An item is (label, body).
#let grid-slide(heading, items, note: none) = slide-page(note: note, {
  header(); footer()
  title(heading)
  for (i, (label, body)) in items.enumerate() {
    let x = (1.323, 12.9).at(calc.rem(i, 2))
    let y = (4.6, 8.9).at(calc.quo(i, 2))
    at(x, y, rect(width: 11.2cm, height: 3.9cm, radius: 0.25cm, fill: muted))
    at(x + 0.5, y + 0.476, txt(12.1, font: mono, fill: accent, [0#(i + 1).]))
    at(x + 0.5, y + 1.191, w: 10.2, txt(12.1, weight: "medium", lh: 109%, upper(label)))
    at(x + 0.5, y + 1.907, w: 10.2, txt(8.9, weight: "regular", lh: 125%, body))
  }
})

// Closing: thanks and contact.
#let closing-slide(heading, contact, note: none) = slide-page(note: note, bg: fill-bg(ink), {
  at(1.654, 4.5, w: 22.5, txt(54, fill: white, heading))
  at(1.654, 11.6, w: 22, caps(10.7, fill: white, contact))
})

#let theme(body) = {
  show: touying-slides.with(config-page(width: 25.4cm, height: 14.287cm, margin: 0pt))
  body
}
