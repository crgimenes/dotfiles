#!/usr/bin/env bash

INITIAL_QUERY="${*:-}"

MARKS_FILES=("$HOME/marks.txt")
[ -f "./marks.txt" ] && \
    MARKS_FILES+=("./marks.txt")

IFS='+' read -r file_path line_number <<< "$(
    cat "${MARKS_FILES[@]}" | \
    fzf --ansi \
        --delimiter '+' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --query "$INITIAL_QUERY"
)"

[ -n "$file_path" ] && {
    file_path=$(echo "$file_path" | xargs)
    line_number=$(echo "$line_number" | xargs)
    "$EDITOR" "$file_path" "+$line_number"
    echo "$file_path" "+$line_number"
}

