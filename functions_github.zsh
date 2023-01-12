###############################################################################
# Git/GitHub
###############################################################################

# Opens the GitHub page of the current repository.
function og() {
    export REPO_URL=$(git config remote.origin.url |
        sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")
    echo "\033[0;32mRepository URL:\033[0m $REPO_URL"
    open $REPO_URL
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
