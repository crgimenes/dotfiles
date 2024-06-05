#!/usr/bin/env bash

[[ -z "${TMUX}" ]] && \
    echo "This script must be run from within tmux" && \
    exit 1

#DIRECTORY=$(find ~/Work ~/Projects ~/Documents ~ -mindepth 1 -maxdepth 1 -type d) && \

SELECTED=${1}
[[ -z "${SELECTED}" ]] && \
    DIRECTORY=$(find ~/Work ~/Projects ~/Documents -mindepth 1 -maxdepth 3 -not -path '*/.*' -type d) && \
    SELECTED=$(echo "${DIRECTORY}" | fzf)

[[ -z "${SELECTED}" ]] && \
    exit 0

SELECTED_NAME=$(basename "${SELECTED}" | tr . _)

# Create a new window se não existir

if ! tmux list-windows | grep -q "${SELECTED_NAME}"; then
    tmux new-window -n "${SELECTED_NAME}" -c "${SELECTED}"
fi

# Move to the window
tmux select-window -t "${SELECTED_NAME}"
