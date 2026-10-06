# Testing guidelines (side projects: maximize real utility per token)

No coverage targets. Test only where a test catches real bugs more cheaply than manual checking.

## What to test
- Pure logic: model/math/state-machine/utility functions, parsers, formatters.
- Invariants that have bitten before (e.g. "feature X is never disabled by condition Y").
- Not worth it: rendering/canvas pixels, CSS/layout feel, UI components, snapshots, glue code.
  Those need eyes, and snapshot tests just create maintenance work.

## Expected values must be independent
Take them from the user's worked examples, textbook/reference values, or hand arithmetic.
Never run the implementation and paste its output in as the expectation: that only proves
the code agrees with itself, and it locks in whatever misunderstanding it was built on.

## When to go spec-first
- New logic with semantic choices (what a term means, sign/unit conventions, edge-case
  behavior): BEFORE implementing, write a short table of 6-10 worked examples and edge cases
  with the reasoning for each, show it to the user, and wait for a skim/OK. Then turn it into
  tests and implement. Concrete examples are the cheapest place for the user to catch a wrong
  conceptual assumption.
- Bug in testable logic: add a failing regression test first, then fix.
- Exploratory/visual work: no tests first. Build, look, adjust.

## Token economy
- Run the fast checks (typecheck, lint, unit tests) before any browser/screenshot verification;
  use the browser only for what needs eyes.
- One small, table-driven test file per logic module (`it.each`), plain assertions, no mocks.
- Don't write tests for code that is about to be thrown away or is still being explored.
