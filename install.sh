#!/bin/bash -ex
DOTFILES_DIR="${HOME}/dotfiles"

source "${DOTFILES_DIR}/bin/log.sh"
source "${DOTFILES_DIR}/bin/user_config.sh"

case $(uname) in
  Darwin)
    IS_DARWIN=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true IS_DARWIN=false
  ;;
esac

inquire () {
  warning "$1"
  while true; do
    read -p "(y/n): " yn
      case $yn in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
      esac
  done
}

download_dotfiles() {
  title "Downloading narugit/dotfiles"
  if [ -e "${DOTFILES_DIR}" ]; then
    if inquire "Remove ${DOTFILES_DIR}?"; then
      rm -rf "${DOTFILES_DIR}"
    else
      error "Abort. You need to remove ${DOTFILES_DIR}"
      exit 1
    fi
  fi
  git clone https://github.com/narugit/dotfiles.git "${DOTFILES_DIR}"
  local GITHUB_PERSONAL_HOST="github-personal"
  (cd "${DOTFILES_DIR}" && git remote set-url origin "${GITHUB_PERSONAL_HOST}:narugit/dotfiles.git")
}

setup_dotfiles_config() {
  title "Setting git user name and email for this repository"
  (cd "${DOTFILES_DIR}" && git config --local user.name "${GIT_CONFIG_LOCAL_USER_NAME}")
  (cd "${DOTFILES_DIR}" && git config --local user.email "${GIT_CONFIG_LOCAL_USER_EMAIL}")
}

install_packages() {
  if ${IS_LINUX}; then
    if inquire "Install apt packages?"; then
      echo "linux"
    fi
  elif ${IS_DARWIN}; then
    if inquire "Install brew packages?"; then
      source "${DOTFILES_DIR}/bin/mac/brew_install.sh"
    fi
  fi
}

change_shell() {
  # change shell to zsh
  if ${IS_LINUX}; then
    info "linux"
    # Linux's default shell is bash, so change to zsh
  fi
}

download_font() {
  # download font from https://github.com/miiton/Cica
  title "Downloading font"
}

setup_zsh() {
  title "Setup zsh"

  local ZSH_DIR_SRC="${DOTFILES_DIR}/etc/zsh"
  local ZSH_DIR_DEST="${HOME}"
  info "Creating symlink for zshrc"
  ln -snfv "${ZSH_DIR_SRC}/.zshrc" "${ZSH_DIR_DEST}/.zshrc"

  local ZSH_CONFS_DIR_SRC="${ZSH_DIR_SRC}/.zsh.d"
  local ZSH_CONFS_DIR_DEST="${HOME}"
  local ZSH_CONFS_SYMLINK="${ZSH_CONFS_DIR_DEST}/.zsh.d"
  if [ -e "${ZSH_CONFS_SYMLINK}" ]; then
    if inquire "Remove ${ZSH_CONFS_SYMLINK}?"; then
      info "Removing directory for zshrc confs"
      rm -rf "${ZSH_CONFS_SYMLINK}"
    else
      error "Abort. You need to remove ${ZSH_CONFS_SYMLINK}"
      exit 1
    fi
  fi
  info "Creating symlink for zshrc confs"
  ln -snfv "${ZSH_CONFS_DIR_SRC}" "${ZSH_CONFS_SYMLINK}"
}

setup_ssh() {
  title "Setup ssh"

  local SSH_DIR_SRC="${DOTFILES_DIR}/etc/ssh"
  local SSH_DIR_DEST="${HOME}/.ssh"
  info "Creating symlink for ssh config"
  ln -snfv "${SSH_DIR_SRC}/config" "${SSH_DIR_DEST}/config"

  local SSH_CONFS_DIR_SRC="${SSH_DIR_SRC}/.config.d"
  local SSH_CONFS_DIR_DEST="${SSH_DIR_DEST}/.config.d"
  if [ -e "${SSH_CONFS_DIR_DEST}" ]; then
    if inquire "Remove ${SSH_CONFS_DIR_DEST}?"; then
      info "Removing directory for ssh configs"
      rm -rf "{SSH_CONFS_DIR_DEST}"
    fi
  else
    info "Creating directory for ssh configs"
    mkdir -p "{SSH_CONFS_DIR_DEST}"
  fi
  info "Creating symlink for ssh confs"
  ln -snfv "${SSH_CONFS_DIR_SRC}"/*.config "${SSH_CONFS_DIR_DEST}"
}

setup_vim() {
  title "Setup vim"
  
  info "Downloading color scheme"
  local VIM_COLOR_DIR="${HOME}/.vim/colors"
  if [ ! -e "${VIM_COLOR_DIR}" ]; then
    info "Creating directory for vim colors"
    mkdir -p "${VIM_COLOR_DIR}"
  fi
  curl -fsSL https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim -o "${VIM_COLOR_DIR}/iceberg.vim"

  local VIM_DIR_SRC="${DOTFILES_DIR}/etc/vim"
  local VIM_DIR_DEST="${HOME}"
  info "Creating symlink for vimrc"
  ln -snfv "${VIM_DIR_SRC}/.vimrc" "${VIM_DIR_DEST}/.vimrc"

  local VIM_INIT_DIR_SRC="${DOTFILES_DIR}/etc/vim/init"
  local VIM_INIT_DIR_DEST="${HOME}/.vim"
  local VIM_INIT_SYMLINK="${VIM_INIT_DIR_DEST}/init"
  if [ -e "${VIM_INIT_SYMLINK}" ]; then
    if inquire "Remove ${VIM_INIT_SYMLINK}?"; then
      info "Removing directory for vimrc (init)"
      rm -rf "${VIM_INIT_SYMLINK}"
    else
      error "Abort. You need to remove ${VIM_INIT_SYMLINK}"
      exit 1
    fi
  fi
  info "Creating symlink for vimrc (init)"
  ln -snfv "${VIM_INIT_DIR_SRC}" "${VIM_INIT_SYMLINK}"

  local VIM_PLUGIN_DIR_SRC="${DOTFILES_DIR}/etc/vim/plugin"
  local VIM_PLUGIN_DIR_DEST="${HOME}/.vim"
  local VIM_PLUGIN_SYMLINK="${VIM_PLUGIN_DIR_DEST}/plugin"
  if [ -e "${VIM_PLUGIN_SYMLINK}" ]; then
    if inquire "Remove ${VIM_PLUGIN_SYMLINK}?"; then
      info "Removing directory for vimrc (plugin)"
      rm -rf "${VIM_PLUGIN_SYMLINK}"
    else
      error "Abort. You need to remove ${VIM_PLUGIN_SYMLINK}"
      exit 1
    fi
  fi
  info "Creating symlink for vimrc (plugin)"
  ln -snfv "${VIM_PLUGIN_DIR_SRC}" "${VIM_PLUGIN_SYMLINK}"

  local DEIN_PLUGINS_DIR_SRC="${VIM_DIR_SRC}/dein"
  local DEIN_PLUGINS_DIR_DEST="${HOME}/.vim/dein/userconfig"
  if [ ! -e "${DEIN_PLUGINS_DIR_DEST}" ]; then
    info "Creating directory for dein plugins"
    mkdir -p "${DEIN_PLUGINS_DIR_DEST}"
  fi
  info "Creating symlink for dein plugins"
  ln -snfv "${DEIN_PLUGINS_DIR_SRC}/plugins.toml" "${DEIN_PLUGINS_DIR_DEST}/plugins.toml"
  ln -snfv "${DEIN_PLUGINS_DIR_SRC}/plugins_lazy.toml" "${DEIN_PLUGINS_DIR_DEST}/plugins_lazy.toml"
}

setup_tmux() {
  title "Setup tmux"

  info "Install tpm"
  local TPM_DIR="${HOME}/.tmux/plugins/tpm"
  git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"

  local TMUX_DIR_SRC="${DOTFILES_DIR}/etc/tmux"
  local TMUX_DIR_DEST="${HOME}"
  info "Creating symlink for tmux"
  ln -snfv "${TMUX_DIR_SRC}/.tmux.conf" "${TMUX_DIR_DEST}/.tmux.conf"

  local TMUX_CONFS_DIR_SRC="${DOTFILES_DIR}/etc/tmux/.tmux.d"
  local TMUX_CONFS_DIR_DEST="${HOME}"
  local TMUX_CONFS_SYMLINK="${TMUX_CONFS_DIR_DEST}/.tmux.d"
  if [ -e "${TMUX_CONFS_SYMLINK}" ]; then
    if inquire "Remove ${TMUX_CONFS_SYMLINK}?"; then
      info "Removing directory for tmux confs"
      rm -rf "${TMUX_CONFS_SYMLINK}"
    else
      error "Abort. You need to remove ${TMUX_CONFS_SYMLINK}"
      exit 1
    fi
  fi
  info "Creating symlink for tmux confs"
  ln -snfv "${TMUX_CONFS_DIR_SRC}" "${TMUX_CONFS_SYMLINK}"
}

setup_git() {
  title "Setup git"
  
  local GIT_CONF_DIR_SRC="${DOTFILES_DIR}/etc/git"
  local GIT_CONF_DIR_DEST="${HOME}"
  info "Creating symlink for git"
  ln -snfv "${GIT_CONF_DIR_SRC}/.gitconfig" "${GIT_CONF_DIR_DEST}/.gitconfig"

  local GITIGNORE_DIR_SRC="${DOTFILES_DIR}/etc/git"
  local GITIGNORE_DIR_DEST="${HOME}"
  info "Creating symlink for gitignore"
  if "${IS_DARWIN}"; then
    ln -snfv "${GITIGNORE_DIR_SRC}/.gitignore_global_mac" "${GITIGNORE_DIR_DEST}/.gitignore_global"
  elif "${IS_LINUX}"; then
    ln -snfv "${GITIGNORE_DIR_SRC}/.gitignore_global_linux" "${GITIGNORE_DIR_DEST}/.gitignore_global"
  fi

  local GIT_CONFS_DIR_SRC="${DOTFILES_DIR}/etc/git/.git.d"
  local GIT_CONFS_DIR_DEST="${HOME}"
  local GIT_CONFS_SYMLINK="${GIT_CONFS_DIR_DEST}/.git.d"
  if [ -e "${GIT_CONFS_SYMLINK}" ]; then
    if inquire "Remove ${GIT_CONFS_SYMLINK}?"; then
      info "Removing directory for git confs"
      rm -rf "${GIT_CONFS_SYMLINK}"
    else
      error "Abort. You need to remove ${GIT_CONFS_SYMLINK}"
    fi
  fi
  info "Creating symlink for git confs"
  ln -snfv "${GIT_CONFS_DIR_SRC}" "${GIT_CONFS_SYMLINK}"
}

setup_peco() {
  title "Setup peco"

  local PECO_CONF_DIR_SRC="${DOTFILES_DIR}/etc/peco"
  local PECO_CONF_DIR_DEST="${HOME}/.config/peco"
  info "Creating symlink for peco"
  if [ ! -e "${PECO_CONF_DIR_DEST}" ]; then
    info "Creating directory for peco conf"
    mkdir -p "${PECO_CONF_DIR_DEST}"
  fi
  ln -snfv "${PECO_CONF_DIR_SRC}/config.json" "${PECO_CONF_DIR_DEST}/config.json"
}

setup_dotfiles_sync_checker() {
  # register tracker for dotfiles modification
  title "Setup dotfiles sync checker"
}

post_install_message() {
  title "Command to enable some package"
  
  info "For zsh, \"$ source ~/.zshrc\""
  info "For tmux, launch tmux then press \"Prefix + I\""
}

download_dotfiles
setup_dotfiles_config
install_packages
change_shell
download_font
setup_zsh
setup_ssh
setup_vim
setup_tmux
setup_git
setup_peco
setup_dotfiles_sync_checker
post_install_message

success "Install successful."
