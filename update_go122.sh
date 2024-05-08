#!/bin/bash

pwd_local=$(pwd)

find . -name "go.mod" -type f | while read -r file; do
    cd "$pwd_local" || exit

    if grep -q -v "go 1.21" "$file"; then
        sed -i -e 's/^go .*$/go 1.22/g' "$file"
        echo "Arquivo $file atualizado para Go 1.22"
    else
        echo "Arquivo $file já está atualizado para Go 1.22"
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
    git commit -m "update to go 1.22"
    git remote -v | grep -q crgimenes && git push

    cd - > /dev/null || exit
done

