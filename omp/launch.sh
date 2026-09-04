#!/usr/bin/env bash
# launch.sh — open an omp agent session beside nvim in a tmux pane,
# with buffer context + code-quality constraints preloaded.
#
# Modes:
#   task text on stdin or via --task   -> message sent immediately (agent
#                                         starts; watch it, Ctrl-C to stop)
#   --file only                        -> plain omp pane; the constraint
#                                         draft is typed in after startup,
#                                         finish the "Task: " line, hit Enter
#   neither                            -> plain pane with constraint prefill
#
# Usage: launch.sh [--file PATH] [--lines A-B] [--task TEXT]
#
# Env:
#   OMP_LAUNCH_PRELUDE  constraint sentence (default: stdlib-first, …)
#   OMP_LAUNCH_SPLIT    pane placement: h side-by-side (default), v below,
#                       w new window
#   OMP_LAUNCH_DELAY    seconds before the draft is typed (default 3)
#   OMP_LAUNCH_CWD      pane working directory (default: current directory)
#   OMP_LAUNCH_TMUX     tmux command prefix (testing hook)
#   OMP_LAUNCH_TARGET   explicit tmux target for the new pane (testing hook)
#   OMP_LAUNCH_CMD      pane command for task mode; %s = draft file path
#   OMP_LAUNCH_OMP      omp binary for draft mode (testing hook)
set -euo pipefail

usage() {
  sed -n '2,21p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

file=""
lines=""
task=""
while [ $# -gt 0 ]; do
  case "$1" in
    --file) file="${2:-}"; shift 2 ;;
    --lines) lines="${2:-}"; shift 2 ;;
    --task) task="${2:-}"; shift 2 ;;
    -h|--help) usage 0 ;;
    *) echo "launch.sh: unknown argument: $1" >&2; usage 2 ;;
  esac
done

# selection piped on stdin joins the task text
if [ ! -t 0 ]; then
  stdin="$(cat 2>/dev/null || true)"
  [ -n "$stdin" ] && task="${task:+$task
}$stdin"
fi

[ -n "${TMUX:-}" ] || { echo "launch.sh: not running inside tmux" >&2; exit 2; }
tmux_cmd() { ${OMP_LAUNCH_TMUX:-tmux} "$@"; }

cwd="${OMP_LAUNCH_CWD:-$PWD}"
prelude="${OMP_LAUNCH_PRELUDE:-stdlib-first, one file, no new deps, smallest useful slice first. Read the referenced file and match its style before writing.}"

fileptr=""
if [ -n "$file" ]; then
  case "$file" in
    "$cwd"/*) file="${file#"$cwd"/}" ;;
  esac
  fileptr="File: $file${lines:+ (lines $lines)}"
fi

case "${OMP_LAUNCH_SPLIT:-h}" in
  h) split=split-window; dir=-h ;;
  v) split=split-window; dir=-v ;;
  w) split=new-window; unset dir ;;
  *) echo "launch.sh: OMP_LAUNCH_SPLIT must be h, v, or w" >&2; exit 2 ;;
esac

tgt=()
[ -n "${OMP_LAUNCH_TARGET:-}" ] && tgt=(-t "$OMP_LAUNCH_TARGET")

if [ -n "$task" ]; then
  # fire-and-go: message via @file, constraints + pointer attached
  draft="Task: $task

$prelude
$fileptr"
  df="$(mktemp /tmp/omp-draft.XXXXXX)"
  printf '%s\n' "$draft" > "$df"
  cmd="$(printf "${OMP_LAUNCH_CMD:-omp @%s}" "$df")"
  tmux_cmd "$split" ${dir+"$dir"} "${tgt[@]}" -c "$cwd" -P -F '#{pane_id}' "$cmd" >/dev/null
else
  # confirm-and-go: draft typed into the composer, user appends task + Enter
  prefill="$(printf '%s %s Task: ' "$prelude" "$fileptr" | tr '\n\t' '  ' | tr -s ' ' | sed 's/^ //; s/ $//')"
  pane="$(tmux_cmd "$split" ${dir+"$dir"} "${tgt[@]}" -c "$cwd" -P -F '#{pane_id}' "${OMP_LAUNCH_OMP:-omp}")"
  # ponytail: fixed-delay prefill; poll pane readiness if it ever flakes
  ( sleep "${OMP_LAUNCH_DELAY:-3}"; tmux_cmd send-keys -t "$pane" -l "$prefill" ) &
fi
