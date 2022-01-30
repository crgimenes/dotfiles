export searx_server="https://home.crg.eti.br/s"

function se() {
    open "${searx_server}/search?q=$( echo $@ )"
}

