#!/bin/bash -e
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"
DOTFILES_RAW_URL_PREFIX="https://raw.githubusercontent.com/narugit/dotfiles/master"

source_remote() {
  local file_relative_path="$1"
  local dir_relative_path=$(dirname ${file_relative_path})
  local local_target_dir="${DOTFILES_TMP_DIR}/${dir_relative_path}"
  local local_target_file="${DOTFILES_TMP_DIR}/${file_relative_path}"
  if [ ! -e "${local_target_dir}" ]; then
    mkdir -p "${local_target_dir}"
  fi
  local remote_file_url="${DOTFILES_RAW_URL_PREFIX}/${file_relative_path}"
  curl -s ${remote_file_url} -o "${local_target_file}"
  source "${local_target_file}"
}

init() {
  rm -rf "${DOTFILES_TMP_DIR}"
  mkdir -p "${DOTFILES_TMP_DIR}"
  
  source_remote "bin/dotfiles_config.sh"
  source_remote "bin/user_config.sh"
  source_remote "bin/log.sh"
  source_remote "bin/check_osname.sh"
}

inquire() {
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
  title "Downloading ${DOTFILES_REPO_URL}"
  if [ -e "${DOTFILES_DIR}" ]; then
    if inquire "Remove ${DOTFILES_DIR}?"; then
      rm -rf "${DOTFILES_DIR}"
    else
      error "Abort. You need to remove ${DOTFILES_DIR}"
      exit 1
    fi
  fi
  git clone "${DOTFILES_REPO_URL}" "${DOTFILES_DIR}"
  (cd "${DOTFILES_DIR}" && git remote set-url origin "${GITHUB_PERSONAL_HOST}:${DOTFILES_REPO}")
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
      source "${DOTFILES_BIN_DARWIN_DIR}/brew_install.sh"
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

  info "Creating symlink for zshrc"
  ln -snfv "${ZSH_DIR_SRC}/.zshrc" "${ZSH_DIR_DEST}/.zshrc"

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

  info "Creating symlink for ssh config"
  ln -snfv "${SSH_DIR_SRC}/config" "${SSH_DIR_DEST}/config"

  if [ -e "${SSH_CONFS_SYMLINK}" ]; then
    if inquire "Remove ${SSH_CONFS_SYMLINK}?"; then
      info "Removing directory for ssh configs"
      rm -rf "{SSH_CONFS_SYMLINK}"
    else
      error "Abort. You need to remove ${SSH_CONFS_SYMLINK}"
      exit 1
    fi
  fi
  info "Creating symlink for ssh confs"
  ln -snfv "${SSH_CONFS_DIR_SRC}" "${SSH_CONFS_DIR_DEST}"
}

setup_vim() {
  title "Setup vim"
  
  info "Downloading color scheme"
  if [ ! -e "${VIM_COLOR_DIR}" ]; then
    info "Creating directory for vim colors"
    mkdir -p "${VIM_COLOR_DIR}"
  fi
  curl -fsSL https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim -o "${VIM_COLOR_DIR}/iceberg.vim"

  info "Creating symlink for vimrc"
  ln -snfv "${VIM_DIR_SRC}/.vimrc" "${VIM_DIR_DEST}/.vimrc"

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

  if [ ! -e "${VIM_DEIN_PLUGINS_DIR_DEST}" ]; then
    info "Creating directory for dein plugins"
    mkdir -p "${VIM_DEIN_PLUGINS_DIR_DEST}"
  fi
  info "Creating symlink for dein plugins"
  ln -snfv "${VIM_DEIN_PLUGINS_DIR_SRC}/plugins.toml" "${VIM_DEIN_PLUGINS_DIR_DEST}/plugins.toml"
  ln -snfv "${VIM_DEIN_PLUGINS_DIR_SRC}/plugins_lazy.toml" "${VIM_DEIN_PLUGINS_DIR_DEST}/plugins_lazy.toml"
}

setup_tmux() {
  title "Setup tmux"

  info "Install tpm"
  git clone https://github.com/tmux-plugins/tpm "${TMUX_TPM_DIR}"

  info "Creating symlink for tmux"
  ln -snfv "${TMUX_DIR_SRC}/.tmux.conf" "${TMUX_DIR_DEST}/.tmux.conf"

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
  
  info "Creating symlink for git"
  ln -snfv "${GIT_CONF_DIR_SRC}/.gitconfig" "${GIT_CONF_DIR_DEST}/.gitconfig"

  info "Creating symlink for gitignore"
  if "${IS_DARWIN}"; then
    ln -snfv "${GIT_IGNORE_DIR_SRC}/.gitignore_global_darwin" "${GIT_IGNORE_DIR_DEST}/.gitignore_global"
  elif "${IS_LINUX}"; then
    ln -snfv "${GIT_IGNORE_DIR_SRC}/.gitignore_global_linux" "${GIT_IGNORE_DIR_DEST}/.gitignore_global"
  fi

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

init
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
