###############################################################################
# Git/GitHub
###############################################################################

# Opens the GitHub page of the current repository.
function og() {
    open $(git config remote.origin.url |
        sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")
}

# Update branch
function update_branch() {
    export branch_name=$(git rev-parse --abbrev-ref HEAD)
    git checkout master
    git fetch -p origin
    git merge origin/master
    git checkout ${branch_name}
    git merge master
    git push origin ${branch_name}
}
