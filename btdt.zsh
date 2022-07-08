# -*- bash -*-
# 
# btdt - remember bash history entries
# Copyright 2022 Anamitra Saha <anamitra.saha21@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

bt() {
    CMD=$1
    if [[ -z "$1" ]]; then
        CMD="$(history -10 | fzf --header="Choose a command to save" --no-sort --tac | cut -d' ' -f 3-)"
    fi

    [[ -z "$CMD" ]] && echo "Aborted" && return 2
    echo "Saving \"${CMD}\"..."
    read "NAME?Name of command: "
    [[ -z "$NAME" ]] && echo "No name given, aborting" && return 1
    read "LONG?Longer description (optional): "

    if [[ ! -d "${HOME}/.config/btdt" ]]; then
        mkdir -p "${HOME}/.config/btdt"
    fi

    DATA="${BTDT_DATA:-${HOME}/.config/btdt/data}"

    if [[ ! -f $DATA ]]; then
        touch $DATA
    fi
    
    result="${CMD}\t${NAME}\t${LONG}\n"
    printf "$result" >> $DATA
}

dt() {
    local data="${BTDT_DATA:-${HOME}/.config/btdt/data}"
    local cmd=$(cat $data | fzf -d'\t' --with-nth 2 --preview='echo -e "\033[1m"{1}"\033[0m""\n\n"{3}' | cut -f1)
    echo "${cmd}"
    eval "${cmd}"
}
