#!/bin/bash
# claude-statusline.sh — shows model, context usage, cost, cwd, and git branch.

# ── Colors ─────────────────────────────────────────────────────────────────
C_CYAN="\033[0;36m"
C_RED="\033[0;31m"
C_YELLOW="\033[0;33m"
C_GREEN="\033[0;32m"
C_OCHRE="\033[38;5;95m"
C_BLUE="\033[0;94m"
C_WHITE="\033[0;37m"
C_DIM="\033[2m"
C_RESET="\033[0m"

# ── Read JSON from stdin ───────────────────────────────────────────────────
json="$(cat)"

jq_val() { printf '%s' "$json" | jq -r "$1 // empty" 2>/dev/null; }

# ── Parse fields ───────────────────────────────────────────────────────────
model="$(jq_val '.model.display_name')"
used_pct="$(jq_val '.context_window.used_percentage')"
cost="$(jq_val '.cost.total_cost_usd')"
cwd="$(jq_val '.cwd')"

# ── Git helpers ────────────────────────────────────────────────────────────
git_status_color() {
  local gs
  gs="$(git -C "$1" status 2>/dev/null)" || return
  if [[ ! $gs =~ "working tree clean" ]]; then
    printf '%s' "$C_RED"
  elif [[ $gs =~ "Your branch is ahead of" ]]; then
    printf '%s' "$C_BLUE"
  elif [[ $gs =~ "Your branch is behind" || $gs =~ "different commits each" ]]; then
    printf '%s' "$C_YELLOW"
  elif [[ $gs =~ "nothing to commit" ]]; then
    printf '%s' "$C_GREEN"
  else
    printf '%s' "$C_OCHRE"
  fi
}

colored_git_branch() {
  local dir="$1"
  local gs on_branch="On branch ([^[:space:]]*)" on_commit="HEAD detached at ([^[:space:]]*)"
  gs="$(git -C "$dir" status 2>/dev/null)" || return
  local label
  if [[ $gs =~ $on_branch ]]; then
    label="${BASH_REMATCH[1]}"
  elif [[ $gs =~ $on_commit ]]; then
    label="${BASH_REMATCH[1]}"
  else
    return
  fi
  printf "$(git_status_color "$dir")%s${C_RESET}" "$label"
}

# ── Assemble the statusline ───────────────────────────────────────────────
output=""
separator=" ${C_GREEN}│${C_RESET} "

# 1. Model
if [[ -n $model ]]; then
  output+="${C_CYAN}${model}${C_RESET}"
fi

# 2. Context usage
if [[ -n $used_pct ]]; then
  local_color="$C_GREEN"
  if (( $(echo "$used_pct > 75" | bc -l 2>/dev/null) )); then
    local_color="$C_RED"
  elif (( $(echo "$used_pct > 50" | bc -l 2>/dev/null) )); then
    local_color="$C_YELLOW"
  fi
  output+=" ${local_color}${used_pct}%${C_RESET}"
fi

# 3. Cost
if [[ -n $cost && $cost != "0" ]]; then
  cost_fmt="$(printf '%.2f' "$cost")"
  output+=" ${C_DIM}\$${cost_fmt}${C_RESET}"
fi

# 4. Separator
output+=$separator

# 5. Current working directory (~ abbreviated)
display_cwd="${cwd/#$HOME/\~}"
output+="${C_CYAN}${display_cwd}${C_RESET}"

# 6. Separator
output+=$separator

# 7. Git branch
branch_seg="$(colored_git_branch "${cwd:-$PWD}")"
if [[ -n $branch_seg ]]; then
  output+=" $branch_seg"
fi

printf "%b\n" "$output"
