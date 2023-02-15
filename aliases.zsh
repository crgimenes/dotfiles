alias ccb='pbpaste|pbcopy' # clear clipboard 
alias copy=pbcopy

#alias ls='ls --time-style="+%Y-%m-%d %H:%M:%S" --color -h'
alias lsa='stat -l -t '%F%T' * | tr ' ' \\t'

alias -s {go,c,json,txt}=vim

alias -g gp='| grep -i' #creates a global alias for grep
# $ ps ax gp ruby
# (all ruby process will be displayed)

alias date_ISO8601_Z='date +%Y-%m-%dT%H:%M:%S%z'
alias date_ISO8601='date -u +%FT%H:%M:%S'

# searX alias
alias \?='se'

# path beautifier 
alias path='echo -e ${PATH//:/\\n}'

alias f='fzf'

# fzf cd
alias zcd=`cd $(find . -type d -print | fzf)`


