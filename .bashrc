# alias
## cd系
alias cdr='cd ~/Documents/research'
alias cdp='cd ~/Documents/programming'
## 文字化け対策（wincmdは下で定義）
alias ping='wincmd ping'
alias narutex='wincmd narutex.cmd'
alias pdfplatex='wincmd pdfplatex.cmd'
## Git Bashでpythonの対話型インタプリタを使用する
alias python='winpty python.exe'

# use pureline-inspired 
source ~/mylib/pureline-inspired/pureline ~/mylib/pureline-inspired/.pureline.conf

# shiftJISで表示された場合の対処用関数
function wincmd() {
    CMD=$1
    shift
    $CMD $* 2>&1 | iconv -f cp932 -t utf-8
}

