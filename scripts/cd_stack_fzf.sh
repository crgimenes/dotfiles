#!/usr/bin/env bash

CD_STACK_MAX="${CD_STACK_MAX:-15}"
CD_STACK_LAST=""

declare -a _CD_STACK=("$PWD")

cd() {
    CD_STACK_LAST=${PWD}
    builtin cd "$@" || return "$?"

    _CD_STACK=("$PWD" "${_CD_STACK[@]}")

    (( ${#_CD_STACK[@]} > CD_STACK_MAX )) && \
        _CD_STACK=("${_CD_STACK[@]:0:CD_STACK_MAX}")

    _CD_STACK=($(printf "%s\n" "${_CD_STACK[@]}" | awk '!x[$0]++'))

    return 0
}

b() {
    cd "${CD_STACK_LAST}" || return "$?"
}

s() {
    local selected
    local formatted_dirs=()

    for dir in "${_CD_STACK[@]}"; do
        formatted_dirs+=("${dir/#"$HOME"/~}")
    done

    selected=$(printf '%s\n' "${formatted_dirs[@]}" | \
        fzf --prompt=": " --height 40% --layout=reverse)

    [[ -z "$selected" ]] && return 0

    local dir="${selected/#\~/$HOME}"

    cd "$dir" || return "$?"

    return 0
}


_initialize_cd_stack_fzf() {
    _CD_STACK=(
        "/Users/crg"
        "/Users/crg/Projects"
    )    
}

_initialize_cd_stack_fzf

