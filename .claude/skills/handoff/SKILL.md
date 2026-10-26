---
name: handoff
description: Hand work off to a fresh context instead of carrying it in the current session. Writes a minimal brief (and a context file when the conversation holds state that is in no file), shows it to the user, then launches a cold subagent, a background session (`claude --bg`), or prints an interactive command. Use when the user says handoff, hand off, park this, "do this in a fresh session", "better compact", or when the session is large (statusline ⚠️/‼️), the user starts a side idea or unrelated workstream, or a subtask needs none of the current context. Offer it proactively in those cases, even if the user did not ask for /handoff.
---

# Hand-off

Purpose: move work into a clean context cheaply. A fork inherits the whole conversation (expensive); a cold subagent or new session starts empty, so everything it needs must be in a short brief written by you, the one who has the context. Quality of the brief is the whole job.

## 1. Pick the situation

| Situation | Launch mode | Reports back? |
|---|---|---|
| Session too big ("better compact") | `--bg` or interactive new session | No (fire-and-forget) |
| Side idea that would derail this session | `--bg` new session | No |
| Subtask that needs none of this context | Cold subagent (Agent tool, brief as prompt) | Yes, ≤200 words, the parent is waiting |

Fork (`subagent_type: "fork"`) only if the task truly needs the conversation; say it is costly. A `--bg` run can report to `docs/handoffs/<slug>.result.md` only if the user asks.

Suggest the mode, do not decide silently. If unsure, say which and why in one line.

## 2. Gather what the receiver needs

Decide what lives where, so the brief stays short:

- **A plan doc already exists** (e.g. `docs/plans/…`): the brief only points to it. Write nothing else.
- **Conversation-only state** (decisions and reasons, rejected options, stated user preferences, half-formed design) that is in no file: write a context file `handoff-dir/<slug>.context.md`, 500-1500 words, sections: Decisions (with reasons), Rejected, User preferences, Open design. Past about a page, suggest promoting it to a plan doc instead.
- **Everything is in files/git**: the brief alone.
- **Large topic still under discussion**: offer to draft a plan first; hand off once the user approves it.

Directory: `docs/handoffs/` in the current repo (create it; on first use ask before adding it to `.gitignore`). Outside a repo use `~/.claude/handoffs/`. Name files `<yyyy-mm-dd>-<slug>.md`.

Run `git status --short | head` and note the branch for "Where". Never include secrets or pasted file contents; use paths.

## 3. Write the brief (≤400 words; ≤800 only if truly needed)

Use `template.md` in this skill's folder. Rules that make it work:

- The receiver knows nothing about this conversation: no "as we discussed", no references to "the current session".
- State **Done when** as something observable (a command passes, a file exists, a question answered).
- Put decisions the user already made under **Decided** so they are not re-litigated; put real unknowns under **Ask the user before**.
- Link the project's CLAUDE.md and house-rules docs by path; do not copy them.
- Add a one-line escape hatch: the parent transcript path, "grep it for a specific detail, never read it whole".
- Notes go in an optional `## Notes` at the end (a few lines: gotchas, hunches). Anything that is really a decision or constraint belongs under its own heading.
- Subagent tasks use the short variant in `template.md` and end with the report format.

Self-check before showing: has a Done-when; no "this conversation"; no secrets; no pasted blocks over ~15 lines; every decision/constraint from the session that the receiver needs is in the brief or the context file; "what could I have forgotten?" answered in one line.

## 4. Show, then launch

Show the user the brief (and context file, if any), the proposed mode, and the permission mode. Launch only after their OK; permissions are asked at each launch.

- Cold subagent: Agent tool with the brief as the prompt.
- Background session: from a trusted directory run
  `claude --bg -n "<short-name>" "Read <path to brief> and follow it."`
  (add `--permission-mode <mode>` as agreed). Tell the user the session name; they reach it with the left-arrow agents list, `claude attach <id>`, `claude logs <id>`. If the directory is untrusted the launch fails with "Workspace not trusted": tell the user to run `claude` there once.
- Interactive: put `claude -n "<name>" "Read <path> and follow it."` on the clipboard (`pbcopy`) and say so.

Afterwards report in two lines: where the brief is and how to reach the new session. For a side idea, then return to the original task without discussing the idea further.

## Nudge etiquette

When offering proactively, do it once per piece of work, in one short line ("Want me to hand this off to a fresh session?"), and drop it if declined.
