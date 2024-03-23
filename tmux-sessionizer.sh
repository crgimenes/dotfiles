#!/usr/bin/env bash

[[ -z "$TMUX" ]] && \
    echo "This script must be run from within tmux" && \
    exit 1

[[ -z "$selected" ]] && \
    selected=$(find ~/Work ~/Projects ~/Documents ~ -mindepth 1 -maxdepth 1 -type d | fzf) || \
    selected=$1

[[ -z "$selected" ]] && \
    exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"

