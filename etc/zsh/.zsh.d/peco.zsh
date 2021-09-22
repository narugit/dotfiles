export HISTFILE=~/.zsh-history
export HISTORY=1000000
export HISTSIZE=1000000
export SAVEHIST=1000000

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
  if "${IS_DARWIN}"; then
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
  elif "${IS_LINUX}"; then
    BUFFER=$(\cat ~/.zsh-history | tac | sed -e 's/^:.*[0-9]\+:[0-9]\+;//g' | awk '!a[$0]++' | peco)
  fi
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

