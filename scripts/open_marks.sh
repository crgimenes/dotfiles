#!/bin/bash

MARKS_FILE="$HOME/marks.txt"

if [[ ! -f "$MARKS_FILE" ]]; then
    echo "Arquivo de marcações não encontrado: $MARKS_FILE"
    exit 1
fi

NVIM_COMMANDS=""

while IFS= read -r line; do
    if [[ "$line" =~ ^(.+)\ \+([0-9]+)$ ]]; then
        file="${BASH_REMATCH[1]}"
        lineno="${BASH_REMATCH[2]}"
        NVIM_COMMANDS="$NVIM_COMMANDS +:edit $file +$lineno"
        continue
    fi
    echo "Formato inválido na linha: $line"
done < "$MARKS_FILE"

if [[ -n "$NVIM_COMMANDS" ]]; then
    nvim $NVIM_COMMANDS
    exit $?
fi
echo "Nenhuma marcação válida encontrada para abrir."
exit 1

