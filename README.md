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
