##############################################################################
# Golang
##############################################################################

# open coverage report in browser
function gocover() {
    echo "Testing..."
    local t="/tmp/go-cover.$$.tmp" 
    go test ./... -coverprofile=$t && \
        go tool cover -html=$t -o /tmp/cover.html && \
        rm -f $t || \
        return 1
    echo "Open /tmp/cover.html"
    open /tmp/cover.html
}


