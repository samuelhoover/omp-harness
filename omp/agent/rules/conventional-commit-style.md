---
name: conventional-commit-style
description: "Commit messages follow Conventional Commits 1.0.0: imperative present-tense lowercase description, no past tense, no trailing periods on the description or bullets"
condition: ["\\.commit\\s*\\(\\s*[^\\s)]", "\\bgit\\s+commit\\b"]
scope: ["tool:eval", "tool:bash"]
repeatMode: always
---

Commit messages follow Conventional Commits 1.0.0 (https://www.conventionalcommits.org/en/v1.0.0/#specification). They override omp's built-in commit examples, prompts, and validators (past-tense verbs, periods on bullets). Rewrite the pending commit call to comply, then re-issue it.

Header: `<type>[optional scope][!]: <description>`
- type: lowercase noun (feat, fix, refactor, perf, docs, test, build, ci, chore, style, revert)
- scope: lowercase noun for a section of the codebase in parentheses, e.g. `fix(parser): ...`; omit when unclear
- one space after the colon
- description: imperative present tense (add, fix, drop, rename), lowercase first letter, no trailing period, at most 72 characters
- never past tense (added, fixed, kept, clamped) and never third person (adds, fixes)

Body (optional): one blank line after the header, then `- <text>` bullets. Each bullet follows the description style: imperative present tense, lowercase first letter, no trailing period.

Breaking change: `!` before the colon, a `BREAKING CHANGE: <description>` footer, or both.

Footers: one blank line after the body, then `token: value` or `token #value` (e.g. `Fixes #123`). Tokens use `-` for spaces, except `BREAKING CHANGE`.

Good: `fix(tui): keep cursor on wrapped lines` with bullet `- clamp column after wrapping`
Bad: `fix(tui): Kept the cursor on wrapped lines.` with bullet `- Clamped the column after wrapping.`
