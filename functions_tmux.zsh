###############################################################################
# tmux
###############################################################################

function msg() {
    for i in $( tmux list-clients | cut -d: -f1 ); do \
        tmux display-message -c $i $1
    done
}


