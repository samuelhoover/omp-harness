# Changelog

Notable changes to this harness. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); the repo has no versions, so history is grouped by date.

## [Unreleased]

### Added
- `/cc` slash command: the `omp commit` protocol (select, analyze, changelog, message, validate, preview, commit) with strict Conventional Commits 1.0.0
- `conventional-commit-style` rule: injects the commit format when the model writes `d.commit(` or `git commit`
- CHANGELOG.md, started from git history
- WISHLIST items 10-13: built-in command shadowing, hardcoded commit style, reminder-only rules, unexplained "Not yours"

### Changed
- commit rule in RULES.md: Conventional Commits 1.0.0, imperative present tense, lowercase description, no trailing periods; it overrides omp's built-in past-tense prompts and validators
- `install.sh` and `check.sh` link and verify `omp/agent/commands/`
- composer shape set to `pi` in config.yml
- README documents `/cc`, the bash push guard, and the commit caveats

## 2026-11-13

### Added
- ASD-STE100 skill and an American English spelling rule
- ponytail plugin with silent auto-update
- cendre-medium theme, set as the default

### Changed
- default model to sonnet-5-5; drop deepseek-v4-pro as fallbacks

## 2026-11-06

### Changed
- model roles to anthropic with deepseek fallbacks
- status line shows usage
- rules avoid periods inside bullet items

## 2026-10-23

### Added
- plotting conventions in the rules

## 2026-10-16

### Added
- consistency checker `omp/check.sh`, wired as a pre-commit hook
- `bash.gitGuard` enabled
- bash tool refuses `git push*`

### Changed
- README caveats for config rewrites, managed skills, and lsp lookup
- launcher env knobs documented
- wishlist statuses reconciled with real session usage

### Fixed
- launcher prunes spent drafts and descends into /tmp
- rust-analyzer root marker kept in the lsp override
- stale references dropped from the research skill
- `--help` prints the whole launcher header

## 2026-10-15

### Added
- basedpyright standard-mode rule for Python edits

### Changed
- thinking block hidden

## 2026-09-22

### Changed
- diff-minimality and response-style rules tightened

## 2026-09-17

### Changed
- keymap snippet notifies on launcher errors

### Fixed
- launcher splits the invoking pane instead of guessing tmux's current window

## 2026-09-16

### Changed
- model roles updated

### Fixed
- nvim keymap snippets in the README

## 2026-09-04

### Changed
- rules require commit approval and forbid pushes

## 2026-09-03

### Added
- tmux agent launcher with context preload
- living wishlist
- Conventional Commits rule

### Changed
- agent config hardened against code bloat

## 2026-09-01

### Added
- trimmed omp harness for single-model use
