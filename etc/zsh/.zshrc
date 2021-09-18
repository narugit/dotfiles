case `uname` in
  Darwin)
    IS_OSX=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true
    IS_OSX=false
  ;;
esac

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"
# readelfとかのPATH
export PATH="/usr/local/opt/binutils/bin:$PATH"
# flutterのPATH
export PATH="$PATH:/Users/naru/develop/flutter/bin"
# android-tools
export PATH="$PATH:/Users/naru/Library/Android/sdk/platform-tools"
# go getを使用するためにGOPATHを設定する
export GOPATH=/Users/naru/app

ZSHHOME="${HOME}/.zsh.d"

if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if "${IS_OSX}"; then
  # ctrl-cがtrapのせいで効かなくなるときのため
  function reset_trap {
    # Hacky hack because of <function/script-that-sets-trap-INT>
    trap - INT
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec reset_trap
fi

