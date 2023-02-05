#!/bin/bash

find . -name "go.mod" -type f | while read -r file; do
    if grep -q -v "go 1.20" "$file"; then
        sed -i -e 's/^go .*$/go 1.20/g' "$file"
        echo "Arquivo $file atualizado para Go 1.20"
    else
        echo "Arquivo $file já está atualizado para Go 1.20"
        continue
    fi

    rm -f "$file-e"

    dir="$(dirname "$file")"
    cd "$dir" || exit

    go get -u ./...
    go mod tidy

    if [ ! -d ".git" ]; then
        echo "Diretório .git não encontrado em $dir"
        continue
    fi
    git add .
    git commit -m "update to go 1.20"
    git push

    cd - > /dev/null || exit
done

