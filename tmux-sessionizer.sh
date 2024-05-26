#!/usr/bin/env bash

[[ -z "${TMUX}" ]] && \
    echo "This script must be run from within tmux" && \
    exit 1


SELECTED=${1}
[[ -z "${SELECTED}" ]] && \
    DIRECTORY=$(find ~/Work ~/Projects ~/Documents -mindepth 1 -not -path '*/.*' -type d) && \
    SELECTED=$(echo "${DIRECTORY}" | fzf)

[[ -z "${SELECTED}" ]] && \
    exit 0

SELECTED_NAME=$(basename "${SELECTED}" | tr . _)

if ! tmux has-session -t="${SELECTED_NAME}" 2> /dev/null; then
    tmux new-session -ds "${SELECTED_NAME}" -c "${SELECTED}"
fi

tmux switch-client -t "${SELECTED_NAME}"

