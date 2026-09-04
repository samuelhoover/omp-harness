Every changed line must trace directly to the user's request.
When your changes orphan imports/variables/functions, remove them.
If tools or repo context can't resolve it, ask rather than assuming.
Prefer the standard library; name why it fails before adding a dependency.
One line of rationale per non-obvious decision.
Smallest useful slice first; show it; continue only on explicit go.
Git commit messages follow Conventional Commits (type(scope): summary).
