#!/usr/bin/env bash

SELECTED=${1}
[[ -z "${SELECTED}" ]] && \
    DIRECTORY=$(find ~/Work ~/Projects ~/Documents -mindepth 1 -maxdepth 3 -not -path '*/.*' -type d) && \
    SELECTED=$(echo "${DIRECTORY}" | fzf)

[[ -z "${SELECTED}" ]] && \
    exit 0

SELECTED_NAME=$(basename "${SELECTED}" | tr . _)

osascript &>/dev/null <<EOF
tell application "iTerm2"
    tell current window
        create tab with default profile
        tell current session of current tab
            write text "cd '${SELECTED}'"
        end tell
    end tell
end tell
EOF

