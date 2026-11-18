---
description: Commit this session's changes with the omp commit protocol and strict Conventional Commits 1.0.0
argument-hint: "[--dry-run] [--no-changelog] [context]"
---

Commit the changes you and your subagents made, following the `omp commit` protocol with the `conventional-commit-style` rule. Other agents and the user edit this worktree concurrently.

Arguments: `$ARGUMENTS`
- `--dry-run`: preview only; write no changelog entry and make no commit
- `--no-changelog`: skip step 3
- other text: extra context about intent

The style in step 4 overrides omp's built-in commit prompts, validators, and examples (past-tense summaries, periods on bullets). The Conventional Commits 1.0.0 spec governs.

## Protocol

1. Select
   - `d = await commit.draft()` in eval; NEVER `git add`, `git commit`, `git stash`, `git reset`, `git checkout`, or `git restore`
   - resolve each `?` item with `d.show()`, `take`, `drop`
   - nothing selected: stop and say so

2. Analyze
   - read `d.diff()`
   - type: feat (any observable behavior change or new public API), fix, refactor (behavior provably unchanged), perf, docs, test, build, ci, chore, style, revert; when in doubt between feat and refactor, pick feat
   - scope: one component noun, lowercase, at most two segments (`a/b`); omit when the change spans components or the scope is a guess; never the project name
   - unrelated changes: split into atomic commits with `d.only(...)`, one message each, dependency order first; draft again after each commit
   - issue refs: only when the diff, the arguments, or the branch name state one; pass `fixes=N`

3. Changelog
   - for each changed file that is not a `CHANGELOG.md`, find the nearest `CHANGELOG.md` walking up to the repo root; group files by changelog
   - skip a changelog without a `## [Unreleased]` section; never create one
   - add entries under `### <category>` inside `[Unreleased]`: Added, Changed, Fixed, Deprecated, Removed, Security, Breaking Changes; reuse existing headings and their order
   - user-visible changes only; skip pure refactor, test, ci, and chore work
   - no trailing period; skip entries already present (case-insensitive); delete entries the change supersedes; match the voice of the existing entries
   - write with `edit`, then `d = await commit.draft()` so each changelog edit rides with the commit it describes; `--dry-run`: list the entries instead of writing them

4. Message (Conventional Commits 1.0.0)
   - header `<type>[(scope)][!]: <description>`
   - description: imperative present tense (add, fix, drop; never added, fixed), lowercase first letter, no trailing period, at most 72 characters, one umbrella for the whole change, not a copy of one bullet
   - do not repeat the type as the first word; no filler (comprehensive, various, several, improved, enhanced, better); no meta phrases (this commit, this change, updated code, modified files)
   - body: omit when the header says it all; else 3-4 bullets (6 at most) grouping outcomes, each `- ` plus imperative present tense, lowercase first letter, at most 120 characters, no trailing period
   - breaking change: `!` before the colon and a `BREAKING CHANGE: <description>` footer after a blank line
   - footers after a blank line: `token: value` or `token #value`

5. Validate; rewrite until every check passes, before showing anything
   - type lowercase from the list in step 2; scope lowercase, no spaces; `: ` after the type
   - description: first letter lowercase, first word imperative (not -ed, -s, -ing, or irregular past such as made, wrote, kept), no trailing period, single line
   - every bullet: `- `, lowercase imperative, no trailing period
   - type matches content: docs needs doc files, test needs test files, ci needs CI config, build needs build files, style has no code changes, refactor adds no new capability, perf has evidence

6. Preview and wait
   - show each message in a code fence, the changed files, and the changelog edits
   - wait for an explicit go; on a decline, undo only the changelog edits you made
   - `--dry-run` stops here and states that nothing was written

7. Commit
   - after the go: `await d.commit("fix(tui): keep cursor on wrapped lines", ["- clamp column after wrapping"], fixes=812)` (shape only; JS takes an options object)
   - on a hook failure, fix the cause; `no_verify` only when the user asks
   - never push; run no tests or builds
   - report each commit hash with its subject, then what remains uncommitted
