#!/usr/bin/env bash

EDITOR=${EDITOR:-vi}

preview_sql() {
  case "$2" in
    sqlite)
      sqlite3 "$1" ".schema" 2>&1
      ;;
    psql)
      PGPASSWORD=${PGPASSWORD:-postgres} psql -U postgres -h localhost -f "$1" 2>&1
      ;;
    *)
      bat --color=always "$1"
      ;;
  esac
}

IFS=: read -ra selected < <(
  rg --color=always --line-number --no-heading --smart-case --glob '*.sql' "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'preview_sql {1} sqlite' \
        --bind 'ctrl-s:execute-silent(preview_sql {1} sqlite)' \
        --bind 'ctrl-p:execute-silent(preview_sql {1} psql)' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
)

if [ -n "${selected[0]}" ]; then
  $EDITOR "${selected[0]}" "+${selected[1]}"
  echo "${selected[0]}" "+${selected[1]}"
fi

