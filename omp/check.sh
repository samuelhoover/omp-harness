#!/usr/bin/env bash
# check.sh — consistency checks for this harness. Run before committing;
# wired as a pre-commit hook in .pre-commit-config.yaml.
#
# Every check maps to a failure this repo has actually had: a launcher knob
# missing from one of its two documentation sites, a setting omp silently
# ignores, malformed JSON, and rules or skills added without re-running
# install.sh.
#
# Env: CHECK_AGENT_DIR — agent directory to inspect (default ~/.omp/agent; a
#      testing hook, as OMP_LAUNCH_TMUX is for launch.sh)
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENT="${CHECK_AGENT_DIR:-$HOME/.omp/agent}"
fail=0
bad() { printf 'FAIL: %s\n' "$*"; fail=1; }

# shell syntax
for s in "$REPO"/omp/*.sh; do
  bash -n "$s" >/dev/null || bad "syntax: ${s#"$REPO"/}"
done

# lint with the shellcheck binary when available, without adding a dependency:
# PATH first, then uvx
sc=()
if command -v shellcheck >/dev/null 2>&1; then
  sc=(shellcheck)
elif command -v uvx >/dev/null 2>&1; then
  sc=(uvx --from shellcheck-py shellcheck)
fi
if [ ${#sc[@]} -gt 0 ]; then
  # SC2100 is a false positive on `split=split-window`; SC2059 is the intended
  # %s template behind OMP_LAUNCH_CMD.
  "${sc[@]}" --severity=warning --exclude=SC2100,SC2059 "$REPO"/omp/*.sh \
    || bad "shellcheck findings"
fi

# every launcher knob appears in --help and in the README table
help_text="$("$REPO/omp/launch.sh" --help)"
for k in $(grep -o 'OMP_LAUNCH_[A-Z]*' "$REPO/omp/launch.sh" | sort -u); do
  case "$help_text" in
    *"$k"*) ;;
    *) bad "launch.sh --help omits $k" ;;
  esac
  grep -q "$k" "$REPO/README.md" || bad "README.md omits $k"
done

# config.yml only sets settings this omp version knows
if command -v omp >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
  python3 - "$REPO/omp/agent/config.yml" <<'PY' || bad "config.yml has keys omp does not accept"
import json, re, subprocess, sys

schema = set(json.loads(subprocess.run(
    ["omp", "config", "list", "--json"], capture_output=True, text=True).stdout))

def known(key):
    return any(key == s or s.startswith(key + ".") or key.startswith(s + ".") for s in schema)

path, unknown = [], []
for line in open(sys.argv[1]):
    body = line.strip()
    if not body or body.startswith("#") or body.startswith("- "):
        continue
    m = re.match(r"^([A-Za-z_][\w.-]*):", body)
    if not m:
        continue
    path = path[: (len(line) - len(line.lstrip())) // 2] + [m.group(1)]
    key = ".".join(path)
    if not known(key):
        unknown.append(key)
for key in unknown:
    print("  unknown setting:", key)
sys.exit(1 if unknown else 0)
PY
fi

# lsp.json parses and every server declares root markers
if command -v python3 >/dev/null 2>&1; then
  python3 - "$REPO/omp/agent/lsp.json" <<'PY' || bad "lsp.json is not usable"
import json, sys

for name, cfg in json.load(open(sys.argv[1]))["servers"].items():
    if not cfg.get("rootMarkers"):
        print(f"  {name}: no rootMarkers")
        sys.exit(1)
PY
fi

# rules and skills are linked from the agent directory into this repo
for f in "$REPO"/omp/agent/rules/*.md "$REPO"/omp/agent/skills/*; do
  [ -e "$f" ] || continue
  case "$f" in
    */rules/*) link="$AGENT/rules/$(basename "$f")" ;;
    *) link="$AGENT/skills/$(basename "$f")" ;;
  esac
  [ "$(readlink "$link" 2>/dev/null)" = "$f" ] \
    || bad "not linked: ${link#"$AGENT"/} (run omp/install.sh)"
done

[ "$fail" -eq 0 ] || { printf 'harness checks failed\n'; exit 1; }
printf 'harness checks passed\n'
