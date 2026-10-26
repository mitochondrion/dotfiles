# Hand-off brief templates

## Full brief (≤400 words, paths not contents; drop empty sections)

```markdown
# Hand-off: <slug>

**Goal:** <one sentence>. **Done when:** <observable condition>.
**Why:** <one or two sentences>.
**Where:** <repo path>, branch <branch>, <clean/dirty summary>.

## Read first (in this order)
- <path>: <why, five words>

## Decided (do not re-litigate)
- <decision>: <reason or user preference>

## Tried and failed
- <approach>: <why it failed>

## Current state
<2-4 lines: what exists, what is half-done>

## Ask the user before
- <action or choice that needs their OK>

## Do not
- <files you don't own, things the user said no to>

## Permissions and output
<mode and tools; where results go, or "none: fire-and-forget">

Parent transcript (escape hatch): <transcript_path>. Grep it for a specific
detail; never read it whole.

## Notes
<optional, a few lines: gotchas, hunches, pointers>
```

## Short brief (cold subagent that reports back)

```markdown
**Goal:** <one sentence>. **Done when:** <observable condition>.
**Where:** <repo path>, branch <branch>.
**Read first:** <paths>
**Constraints:** <files you may edit; things not to touch>
**Report (≤200 words):** what changed or was found (files), checks run and
results, errors or disagreements first, unverified items, questions.
```

## Context file (only when the conversation holds state that is in no file)

`<slug>.context.md`, 500-1500 words:

```markdown
# Context: <slug>
## Decisions (with reasons)
## Rejected options (and why)
## User preferences stated
## Open design / unfinished thinking
```
