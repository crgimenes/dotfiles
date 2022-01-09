###############################################################################
# GitHub
###############################################################################

# Opens the GitHub page of the current repository.
function og() {
    open $(git config remote.origin.url |
        sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")
}


