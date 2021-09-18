export TERM="xterm-256color"

if "${IS_OSX}"; then
  # ctrl-cがtrapのせいで効かなくなるときのため
  function reset_trap {
    # Hacky hack because of <function/script-that-sets-trap-INT>
    trap - INT
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec reset_trap
fi
