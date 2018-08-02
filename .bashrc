# alias
alias cdr='cd ~/Documents/research'
alias cdp='cd ~/Documents/programming'
alias ping='wincmd ping'
alias narutex='wincmd narutex.cmd'
alias pdfplatex='wincmd pdfplatex.cmd'

# use pureline-inspired 
source ~/mylib/pureline-inspired/pureline ~/mylib/pureline-inspired/.pureline.conf

# shiftJISで表示された場合の対処用関数
function wincmd() {
    CMD=$1
    shift
    $CMD $* 2>&1 | iconv -f cp932 -t utf-8
}

