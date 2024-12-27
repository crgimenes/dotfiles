#!/usr/bin/env bash

CD_STACK_MAX="${CD_STACK_MAX:-15}"
CD_STACK_LAST=""

declare -a _CD_STACK=("$PWD")

_cd_save_env() {
    {
        declare -p _CD_STACK
        declare -p CD_STACK_LAST
    } > ~/.cd_stack_fzf.tmp && \
        mv ~/.cd_stack_fzf.tmp ~/.cd_stack_fzf
}

_cd_load_env() {
    [[ -f ~/.cd_stack_fzf ]] && \
        source ~/.cd_stack_fzf
}

cd() {
    CD_STACK_LAST=${PWD}
    builtin cd "$@" || return "$?"

    _CD_STACK=("$CD_STACK_LAST" "${_CD_STACK[@]}")

    [ "${#_CD_STACK[@]}" -gt "$CD_STACK_MAX" ] && \
        unset '_CD_STACK[-1]'

    _CD_STACK=($(printf "%s\n" "${_CD_STACK[@]}" | \
        awk '!x[$0]++'))

    _cd_save_env
    return 0
}

b() {
    _cd_load_env
    cd "${CD_STACK_LAST}" || return "$?"
    _cd_save_env
}


s() {
    _cd_load_env
    local selected
    local formatted_dirs=()
    local query=""

    if (( $# > 0 )); then
        query="$*"
    fi

    for dir in "${_CD_STACK[@]}"; do
        formatted_dirs+=("${dir/#"$HOME"/~}")
    done

    selected=$(printf '%s\n' "${formatted_dirs[@]}" | \
        fzf --prompt=": " \
            --height 40% \
            --layout=reverse \
            ${query:+--query="$query"})

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
    _cd_load_env
}

_initialize_cd_stack_fzf

