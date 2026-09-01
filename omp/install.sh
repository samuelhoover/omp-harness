#!/usr/bin/env bash
# Install/sync the omp harness dotfiles into this machine.
# Idempotent: safe to re-run. Existing real files are backed up once to *.pre-dotfiles.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENT="${PI_CODING_AGENT_DIR:-$HOME/.omp/agent}"

link() { # link <target> <linkpath>
  local target="$1" path="$2"
  mkdir -p "$(dirname "$path")"
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    if [ -e "$path.pre-dotfiles" ]; then rm -rf "$path.pre-dotfiles"; fi
    mv "$path" "$path.pre-dotfiles"
    echo "moved $path -> $path.pre-dotfiles"
  fi
  ln -sfn "$target" "$path"
}

# --- config files (symlinked: edits via `omp config set` land in the repo) ---
link "$REPO/omp/agent/config.yml" "$AGENT/config.yml"
link "$REPO/omp/agent/AGENTS.md"  "$AGENT/AGENTS.md"
link "$REPO/omp/agent/RULES.md"   "$AGENT/RULES.md"
link "$REPO/omp/agent/models.yml" "$AGENT/models.yml"
for f in SYSTEM.md lsp.json; do
  [ -e "$REPO/omp/agent/$f" ] && link "$REPO/omp/agent/$f" "$AGENT/$f"
done
for s in "$REPO"/omp/agent/skills/*; do
  [ -e "$s" ] || continue
  link "$s" "$AGENT/skills/$(basename "$s")"
done
# drop links to skills that no longer exist in the repo (ours, dangling only)
for s in "$AGENT"/skills/*; do
  [ -L "$s" ] || continue
  case "$(readlink "$s")" in
    "$REPO"/*)
      [ -e "$s" ] || { rm -f "$s"; echo "removed stale skill link $s"; }
      ;;
  esac
done
for s in "$REPO"/omp/agent/rules/*; do
  [ -e "$s" ] || continue
  link "$s" "$AGENT/rules/$(basename "$s")"
done
# drop links to rules that no longer exist in the repo (ours, dangling only)
for s in "$AGENT"/rules/*; do
  [ -L "$s" ] || continue
  case "$(readlink "$s")" in
    "$REPO"/*)
      [ -e "$s" ] || { rm -f "$s"; echo "removed stale rule link $s"; }
      ;;
  esac
done
# warn about skills/rules not mirrored from the repo (machine-local drift)
drift() { # drift <dir>: warn about entries not mirrored from the repo
  for e in "$1"/*; do
    [ -e "$e" ] || continue
    b="$(basename "$e")"
    if [ -L "$e" ]; then
      case "$(readlink "$e")" in
        "$REPO"/*) ;;
        *) echo "WARN: $e is a symlink outside the dotfiles repo";;
      esac
    elif [ "$b" != ".DS_Store" ] && [ "${b##*.}" != "pre-dotfiles" ]; then
      echo "WARN: $e is machine-local (not a repo symlink)"
    fi
  done
}
drift "$AGENT/skills"
drift "$AGENT/rules"
echo "harness installed from $REPO"
