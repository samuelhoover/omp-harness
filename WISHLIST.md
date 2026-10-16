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

## P2 — Output discipline & trust

### 6. Show-before-apply with accept/reject for existing code
- Ask: default flow presents a diff of pending hunks; accept/reject per hunk
  before anything lands.
- Repo coverage: AGENTS.md §2/§6 (small reviewable steps) approximate it.
- Evidence: trust-mechanics answers (diff-first), 2026-09-03; asked again on
  2026-09-15, 2026-09-28 and 2026-10-12, twice on each date. Partly covered by
  the RULES.md >20-line/multi-file diff gate; no per-hunk accept.
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

## Update log

- 2026-09-03 — created from the onboarding interview; no real usage yet, so
  statuses are guesses. Focus: P0 pick-up. Expected to churn fast once daily
  use starts.
- 2026-10-16 — checked against 33 archived sessions (2026-09-01 → 10-16).
  Items 3, 5 and 6 move to `tried`: the launcher prelude ran in a live
  cng_labels session (10-09), and the diff-first ask recurred on three later
  dates. Item 4's note was wrong about adoption — task mode is already the
  path in use. Nothing has enough repeat use to call `adopted` yet.
