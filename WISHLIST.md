# omp wishlist — usability for my workflow

Living list of what oh-my-pi must do to earn daily use. Main priority:
**pick-up-and-use inside my existing nvim/tmux workflow, with output I trust** —
everything else ranks below that.

## How to keep this list

- When a friction costs you time in a real session, add it the same day:
  What happened / Why it hurt / The fix that removes it. One or two lines each.
- Status flow: `idea → tried → adopted | dropped | filed`. Mark it the moment
  you know; entries stop being guesses once you've hit them in real use.
- If an existing feature removes the friction, close the item with
  `dropped (covered by …)`.
- Re-rank when the list passes ~15 items or once a quarter. Prune what stopped
  hurting.
- `filed` entries link the upstream issue.

Statuses: idea (untested guess) · tried (used/verified once) · adopted ·
dropped · filed. Priority: P0 = blocks daily use; P1 = real friction;
P2 = nice.

## P0 — Pick-up & onboarding (current focus)

### 1. Value from defaults + one prompt
- Problem: adoption cost was learning surface + setup overhead — roles,
  skills, rules, config felt required before any value.
- Ask: a bare `omp "stdlib-only python one-off for X"` in any repo should
  behave well with zero config; new concepts should be learnable after the
  first win, not before it.
- Evidence: adoption-cost interview answers (learning surface, setup
  overhead), 2026-09-03.
- Status: idea.

### 2. Explain per-model choices instead of hiding them
- Problem: "why is there no max thinking for deepseek-v4-flash?" — per-model
  effort ladders differ silently and the menu doesn't say why.
- Ask: when an option is absent for the current model, say why (supported
  efforts, what the top tier maps to on the wire).
- Evidence: first-session question, 2026-09-03.
- Status: idea.

### 3. Inline constraint lines as a real contract
- Problem: "stdlib-only, one file, no new deps" works only when the model
  complies — prompt luck today.
- Ask: constraints typed with the task (no config) are treated as session
  rules and visible in the status line.
- Repo coverage: launch.sh prelude + AGENTS.md §6 restate them; still
  unenforced upstream.
- Evidence: trust-mechanics answers (per-task constraint lines), 2026-09-03;
  the launcher prelude carried the sentence into two live cng_labels prompts,
  2026-10-09 (session 01a11dc1).
- Status: tried.

## P1 — Workflow fit (nvim/tmux)

### 4. Thinner launch glue
- Problem: launch.sh needs an `@file` message plus send-keys timing; the
  draft prefill is a fixed delay and can miss a slow boot.
- Ask: an omp-side "start session with draft" contract (no typing race) and
  documented extension hooks, so the nvim→tmux path is a few lines, not a
  90-line script.
- Evidence: launch.sh `ponytail:` comment, 2026-09-03.
- Status: tried (task mode ran in real cng_labels work, 2026-10-09; draft
  mode still unexercised). Upstream ask open.

### 5. Style grounding without context-file authoring
- Problem: making output match my code style requires AGENTS.md prose or
  hand-written context files.
- Ask: "match the style of these files" as a first-class pointer that loads
  exemplars with no config authoring.
- Repo coverage: launch.sh `File:` pointer + AGENTS.md §6.2 approximate it.
- Evidence: trust-mechanics answers (style grounding), 2026-09-03; on
  2026-10-09 the prelude's `File:` pointer was followed by a `read` of that
  file before any write (session 01a11dc1).
- Status: tried.

### 10. File commands cannot override built-ins
- Problem: `/commit` is a built-in dispatched before file commands, so a
  `commands/commit.md` never runs; the custom commit flow had to be named `/cc`.
- Ask: let a user or project command shadow a built-in on purpose, or say at
  startup that a file command is shadowed.
- Repo coverage: `/cc` in `omp/agent/commands/`.
- Evidence: slash-command-internals.md §5 (built-ins dispatch first); the
  built-in `/commit` prompt has no changelog step and no style rules,
  2026-11-18.
- Status: idea.

## P2 — Output discipline & trust

### 6. Show-before-apply with accept/reject for existing code
- Ask: default flow presents a diff of pending hunks; accept/reject per hunk
  before anything lands.
- Repo coverage: AGENTS.md §2/§6 (small reviewable steps) approximate it.
- Evidence: trust-mechanics answers (diff-first), 2026-09-03; asked again on
  2026-09-15, 2026-09-28 and 2026-10-12, twice on each date. Partly covered by
  the RULES.md >20-line/multi-file diff gate and `/cc`'s preview-and-wait
  step; no per-hunk accept.
- Status: tried.

### 7. Rationale-per-decision output mode
- Ask: a terse-annotation mode — one line per non-obvious choice, no prose
  walls.
- Repo coverage: AGENTS.md §5.
- Evidence: trust-mechanics answers, 2026-09-03.
- Status: idea.

### 8. Built-in slice steering
- Ask: smallest useful slice → pause → continue only on explicit go, as a
  flow rather than a prompt convention.
- Repo coverage: AGENTS.md §6.3 + RULES.md slice rule.
- Evidence: trust-mechanics answers, 2026-09-03.
- Status: idea.

### 9. History mining is reachable but hidden
- Problem: `read xd://eval/archive` answers "Tool 'eval' has no doc topics",
  and subagents get no `eval` at all — the archive API works only for a
  top-level session that already knows it exists.
- Ask: ship the `xd://eval/archive` topic, and let a subagent mine history (the
  audit's history pass fell back to raw SQLite + JSONL greps).
- Evidence: 2026-10-16 harness audit of this repo — both failures reproduced.
- Status: idea.

### 11. Commit style is hardcoded
- Problem: `omp commit` validates past-tense summaries and periods on detail
  bullets, and the built-in `/commit` and eval `commit` docs show past tense;
  Conventional Commits 1.0.0 requires neither, and my rule is imperative with
  no periods.
- Ask: a setting or rule hook for commit style (tense, bullet punctuation) that
  the validators and prompts honor.
- Repo coverage: RULES.md, the `conventional-commit-style` rule, and `/cc`
  override the prompts in-session; the CLI stays unusable for this style.
- Evidence: strings in the 18.22.2 binary ("Summary must start with a
  past-tense verb", "Body item is missing a period"), 2026-11-18.
- Status: idea.

### 12. Rules can remind but not block
- Problem: a `repeatMode: always` rule is exempt on its own retry, so the
  commit-style rule injects the format once per attempt and never checks what
  lands; it also interrupts compliant commits (2 triggers for 1 commit).
- Ask: a rule mode that re-checks the retry with a bound, or a gate that fires
  only on violations.
- Repo coverage: RULES.md lines and `/cc` step 5 (validate before preview)
  - a `commit-msg` hook would be a hard block, but it checks format exactly
    and tense detection stays heuristic; not adopted (2026-11-18, option A)
  - a second violation rule would alternate with the first, with no bound per
    ttsr-injection-lifecycle.md §5 (reading of the docs, untested)
- Evidence: ttsr-injection-lifecycle.md §5; live throwaway-repo runs, 2026-11-18.
- Status: tried.

### 13. "Not yours" does not say why
- Problem: with `--no-session`, `commit.draft()` reports the session's own
  `edit` and `write` changes as "Not yours" and never says the journal is
  missing.
- Ask: name the cause in the message.
- Evidence: two `/cc` runs with `--no-session` stopped at step 1; the same
  flow without it attributed correctly, 2026-11-18
  - the cause is inferred from the flag difference, not read from source
- Status: idea.

## Update log

- 2026-09-03 — created from the onboarding interview; no real usage yet, so
  statuses are guesses. Focus: P0 pick-up. Expected to churn fast once daily
  use starts.
- 2026-10-16 — checked against 33 archived sessions (2026-09-01 → 10-16).
  Items 3, 5 and 6 move to `tried`: the launcher prelude ran in a live
  cng_labels session (10-09), and the diff-first ask recurred on three later
  dates. Item 4's note was wrong about adoption — task mode is already the
  path in use. Nothing has enough repeat use to call `adopted` yet.
- 2026-11-18 — reconciled with the repo since 10-16 (see CHANGELOG.md)
  - repo changes since: model roles moved to anthropic with deepseek
    fallbacks, ponytail and ASD-STE100 plugins, cendre-medium theme, plotting,
    American English and bullet rules
  - added `/cc` and the commit-style rule; items 10-13 come from that work
  - no session-archive check this time, so statuses of items 1-9 are unchanged
