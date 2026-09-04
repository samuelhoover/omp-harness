# harness

My omp agent configuration: settings, context files, tool-scoped rules, one skill. Everything is symlinked from `~/.omp/agent` so edits made through omp (e.g. `omp config set`) land in this repo — `git diff` shows config drift.

## Contents

    omp/agent/config.yml    settings (modelRoles, statusLine, task, advisor off, …)
    omp/agent/AGENTS.md     behavioral guidelines
    omp/agent/RULES.md      generic one-line rules (union-merged on pull)
    omp/agent/models.yml    deepseek provider definition (API key from DEEPSEEK_API_KEY env)
    omp/agent/lsp.json      LSP overrides (basedpyright, ruff, rust-analyzer)
    omp/agent/rules/        tool-scoped rules (no-browser, no-secrets)
    omp/agent/skills/       skills (research)
    omp/launch.sh           nvim→tmux launcher: agent pane with buffer context + constraints preloaded
    omp/install.sh          idempotent installer / re-linker
System prompt: omp built-in default — no SYSTEM.md file (kept absent on purpose).

Not included (machine-local by design): credentials (~/.omp/agent/agent.db), sessions, caches, git identity.

## Install on a new machine

Prerequisites: omp installed, git identity set, DEEPSEEK_API_KEY in the environment.

    git clone https://github.com/samuelhoover/omp-harness.git ~/harness
    ~/harness/omp/install.sh

Safe to re-run anytime — it re-points symlinks and never touches files it didn't create.

## Update

Edits made through omp (config set, rules, skills) write through the symlinks into the repo. Commit them:

    cd ~/harness && git add -A && git commit -m "…" && git push

Pull on other machines: `git pull && ~/harness/omp/install.sh`.

## Agent launch glue (nvim → tmux)

`omp/launch.sh` opens an omp session in a tmux pane beside nvim, pointed at the
current directory, with buffer context and code-quality constraints preloaded.
Run inside tmux. Add to `~/.config/nvim/init.lua` (or wherever mappings live):

```vim
" normal: pane opens, constraint draft typed in — append a task, press Enter
nnoremap <silent> <leader>a :call system('~/harness/omp/launch.sh --file ' . shellescape(expand('%:p')))<CR>
" visual: selection becomes the task; the agent starts immediately
vnoremap <silent> <leader>a :<C-u>call system('~/harness/omp/launch.sh --file ' . shellescape(expand('%:p')) . ' --lines ' . line("'<") . '-' . line("'>"), join(getline("'<", "'>"), "\n"))<CR>
```

The draft carries the stdlib-first constraint line and the `File:` pointer, so
the agent reads and matches your code before writing. Useful knobs (env):

| Variable | Default | Meaning |
| --- | --- | --- |
| `OMP_LAUNCH_PRELUDE` | stdlib-first, one file, no new deps, smallest useful slice first… | constraint sentence |
| `OMP_LAUNCH_SPLIT` | `h` | pane placement: `h` beside, `v` below, `w` new window |
| `OMP_LAUNCH_DELAY` | `3` | seconds to wait before typing the draft (raise if omp boots slowly) |
