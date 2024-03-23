#!/usr/bin/env bash

selected=$1
[[ -z "$selected" ]] && \
    selected=$(find ~/Work ~/Projects ~/Documents ~ -mindepth 1 -maxdepth 1 -type d | fzf)

[[ -z "$selected" ]] && \
    exit 0

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

[[ -z "$TMUX" ]] && [[ -z "$tmux_running" ]] && \
    tmux new-session -s "$selected_name" -c "$selected" && \
    exit 0

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"

