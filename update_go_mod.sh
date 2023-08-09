#!/bin/bash

find . -name "go.mod" -type f | while read -r file; do
    dir=$(dirname "$file")
    cd "$dir" || exit

    go get -u ./...
    go mod tidy

    git add .
    git commit -m "update go mod"
    git push


    if [ ! -d ".git" ]; then
        echo "Diretório .git não encontrado em $dir"
        cd - > /dev/null || exit
        continue
    fi
    git add .
    git commit -m "update to go mod"
    git push

    cd - > /dev/null || exit
done

