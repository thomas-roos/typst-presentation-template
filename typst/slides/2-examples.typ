// One example per layout in theme.typ. Delete what you don't need.
#import "../theme.typ": *

#divider(1, [Section \ title])

#statement[One sentence the audience *should remember*.]

#heading-slide([Big \ *heading*], [
  Body text on the right. A blank line starts a new paragraph.

  *Bold* is set in medium weight.
])

#question-slide([Title], [Some context for the question.], [The question], [What would you do?])

#result-slide([Code and result], [
  ```c
  int main(void) { return 0; }
  ```
], [Result], [It compiles.])

#cards-slide([Two options], [A subtitle], [Text on the left that introduces the cards.],
  ([Option A], [First], [What it does.]),
  ([Option B], [Second], [What it does.]),
)

#flow-slide([Steps], [How it works], (
  ([Plan], [Decide what to build.]),
  ([Build], [Write it.]),
  ([Test], [Check it.]),
  ([Ship], [Release it.]),
), below: [Optional text below the steps.])

#boxes-slide([Takeaways], ([First point.], [Second point.], [Third point, \ two lines.], [Fourth point.]))

// Free layout: place anything with at(x, y) in cm.
#slide-page({
  header(); footer()
  title([Free layout])
  at(1.323, 4, w: 22, txt(12.5)[Use `at(x, y, w: …)` and `txt(size)` for anything the layouts don't cover.])
})

#closing-slide([Thank you], [name\@example.com · example.com])
