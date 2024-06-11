#!/usr/bin/env bash

EDITOR=${EDITOR:-vi}

function runcmd() {
  local file=$1
  local db=$2
  echo "Running $db $file"
  exit 0
}

# Define cores para o header
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Monta o header com cores
HEADER=$(printf "${RED}ˆs${NC} sqlite, ${GREEN}^p${NC} psql, ${YELLOW}return${NC} edit")


IFS=: read -ra selected < <(
  rg --color=always --line-number --no-heading --smart-case --glob '*.sql' "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --header "$HEADER" \
        --bind 'ctrl-s:execute(runcmd {1} sqlite)' \
        --bind 'ctrl-p:execute(runcmd {1} psql)' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
)

if [ -n "${selected[0]}" ]; then
  $EDITOR "${selected[0]}" "+${selected[1]}"
  echo "${selected[0]}" "+${selected[1]}"
fi

