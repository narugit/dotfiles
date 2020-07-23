HISTFILE=~/.zsh-history
HISTORY=1000000
SAVEHIST=1000000

# 履歴をインクリメンタルに追加
setopt inc_append_history
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 古いコマンドと同じものは無視
setopt hist_save_no_dups
# historyを共有
setopt share_history
# 重複を記録しない
setopt hist_ignore_dups
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

function peco-select-history() {
    case ${OSTYPE} in
        darwin*)
        BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
        ;;
        linux*)
        BUFFER=$(\cat ~/.zsh-history | sed -e 's/^:.*[0^9]\+:[0-9]\+;//g' | awk '!a[$0]++' | peco)
        ;;
    esac
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

