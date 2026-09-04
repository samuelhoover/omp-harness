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
- Evidence: trust-mechanics answers (per-task constraint lines), 2026-09-03.
- Status: idea.

## P1 — Workflow fit (nvim/tmux)

### 4. Thinner launch glue
- Problem: launch.sh needs an `@file` message plus send-keys timing; the
  draft prefill is a fixed delay and can miss a slow boot.
- Ask: an omp-side "start session with draft" contract (no typing race) and
  documented extension hooks, so the nvim→tmux path is a few lines, not a
  90-line script.
- Evidence: launch.sh `ponytail:` comment, 2026-09-03.
- Status: tried (launch.sh verified in both modes; not yet used in daily
  flow). Upstream ask open.

### 5. Style grounding without context-file authoring
- Problem: making output match my code style requires AGENTS.md prose or
  hand-written context files.
- Ask: "match the style of these files" as a first-class pointer that loads
  exemplars with no config authoring.
- Repo coverage: launch.sh `File:` pointer + AGENTS.md §6.2 approximate it.
- Evidence: trust-mechanics answers (style grounding), 2026-09-03.
- Status: idea.

## P2 — Output discipline & trust

### 6. Show-before-apply with accept/reject for existing code
- Ask: default flow presents a diff of pending hunks; accept/reject per hunk
  before anything lands.
- Repo coverage: AGENTS.md §2/§6 (small reviewable steps) approximate it.
- Evidence: trust-mechanics answers (diff-first), 2026-09-03.
- Status: idea.

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

## Update log

- 2026-09-03 — created from the onboarding interview; no real usage yet, so
  statuses are guesses. Focus: P0 pick-up. Expected to churn fast once daily
  use starts.
