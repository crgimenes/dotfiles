#!/bin/zsh

export rmenu=$(fzf --border=rounded --margin=5% --color=dark --height 100% --reverse --header=$(basename "Menu") --info=hidden --header-first --prompt "$")
open "$rmenu"

