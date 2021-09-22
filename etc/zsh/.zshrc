DOTFILES_DIR="${HOME}/dotfiles"
source "${DOTFILES_DIR}/bin/check_os.sh"

ZSH_CONFS_DIR="${HOME}/.zsh.d"
ZSH_PRIORITIES_CONF="${ZSH_CONFS_DIR}/priorities.conf"
ZSH_SECRET_CONF="${HOME}/.zshrc.secret"

source "${ZSH_PRIORITIES_CONF}"

for zsh_conf in ${ZSH_CONFS}; do
  source "${ZSH_CONFS_DIR}/${zsh_conf}"
done

if [ -e "${ZSH_SECRET_CONF}" ]; then
  source "${ZSH_SECRET_CONF}"
fi
