##############################################################################
# Darwin only
##############################################################################


###############################################################################
# Apple Music
###############################################################################

# Get the current track and artist from Apple Music
function plaing() {
    osascript -e 'tell application "Music" to return (name of current track) & " - " & (artist of current track)'
}

###############################################################################
# Finder
###############################################################################

# Finder current directory in the terminal
function fcd() {                                                                    
    pFinder=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    [ -n "$pFinder" ] && cd "$pFinder"
    pwd
}

# micelaneous

function xmanpage() { open x-man-page://$@ ; }

