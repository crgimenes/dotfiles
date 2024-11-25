#!/usr/bin/env bash

MARKS_FILE="$HOME/marks.txt"

[[ ! -f "$MARKS_FILE" ]] && {
    echo "Arquivo de marcações não encontrado: $MARKS_FILE"
    exit 1
}

NVIM_COMMANDS=""

while IFS= read -r line; do
    [[ "$line" =~ ^(.+)\ \+([0-9]+)$ ]] && {
        file="${BASH_REMATCH[1]}"
        lineno="${BASH_REMATCH[2]}"
        NVIM_COMMANDS="$NVIM_COMMANDS +:edit $file +$lineno"
        continue
    }
    echo "Formato inválido na linha: $line"
done < "$MARKS_FILE"

[[ -n "$NVIM_COMMANDS" ]] && {
    nvim $NVIM_COMMANDS
    exit $?
}
echo "Nenhuma marcação válida encontrada para abrir."
exit 1

