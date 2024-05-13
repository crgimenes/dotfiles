###############################################################################
# tmux
###############################################################################

function msg() {
    for i in $( tmux list-clients | cut -d: -f1 ); do \
        tmux display-message -c $i $1
    done
}

function t() {
    SESSION_NAME="default"
    if [ -n "$1" ]; then
        SESSION_NAME=$1
    fi

    if [ -z "$TMUX" ]; then
        tmux new -A -s "${SESSION_NAME}"
        return
    fi
    
    if ! tmux has-session -t="${SESSION_NAME}" 2> /dev/null; then
        tmux new-session -ds "${SESSION_NAME}"
    fi

    tmux switch-client -t "${SESSION_NAME}"
}

