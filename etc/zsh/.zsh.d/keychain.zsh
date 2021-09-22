if "${IS_LINUX}"; then
  keychain "${HOME}/.ssh/id_rsa_personal" &> /dev/null
  source "$HOME/.keychain/`hostname`-sh"
fi
