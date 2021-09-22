#!/bin/bash -e
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"
DOTFILES_RAW_URL_PREFIX="https://raw.githubusercontent.com/narugit/dotfiles/master"
IS_WANTED_BACKUP=True

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

safety_remove() {
  local target="$1"
  local remove_message="Removing ${target}"
  if "${IS_WANTED_BACKUP}"; then
    info "${remove_message}"
    rm -rf "${target}"
  else
    if inquire "Remove ${target}?"; then
      info "${remove_message}"
      rm -rf "${target}"
    else
      error "Abort. You need to remove ${target}"
      exit 1
    fi
  fi
}

backup_dir_file() {
  local target="$1"
  local dest_dirname="$2"
  local dest="${DOTFILES_BACKUP_DIR}/${dest_dirname}"
  if [ -e "${target}" ]; then
    info "Backup ${target} to ${dest}"
    yes | cp -RL "${target}" "${dest}"
  fi
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

backup_zsh() {
  title "Backup zsh"
  local zsh_dir="zsh"

  backup_dir_file "${ZSH_DIR_DEST}/.zshrc" "${zsh_dir}"
  backup_dir_file "${ZSH_CONFS_SYMLINK}" "${zsh_dir}"
}

link_zsh() {
  title "Setup zsh"

  info "Creating symlink for zshrc"
  ln -snfv "${ZSH_DIR_SRC}/.zshrc" "${ZSH_DIR_DEST}/.zshrc"

  if [ -e "${ZSH_CONFS_SYMLINK}" ]; then
    safety_remove "${ZSH_CONFS_SYMLINK}"
  fi
  info "Creating symlink for zshrc confs"
  ln -snfv "${ZSH_CONFS_DIR_SRC}" "${ZSH_CONFS_SYMLINK}"
}

backup_ssh() {
  title "Backup ssh"
  local ssh_dir="ssh"

  backup_dir_file "${SSH_DIR_DEST}/config" "${ssh_dir}"
  backup_dir_file "${SSH_CONFS_SYMLINK}" "${ssh_dir}"
}

link_ssh() {
  title "Setup ssh"

  info "Creating symlink for ssh config"
  ln -snfv "${SSH_DIR_SRC}/config" "${SSH_DIR_DEST}/config"

  if [ -e "${SSH_CONFS_SYMLINK}" ]; then
    safety_remove "${SSH_CONFS_SYMLINK}"
  fi
  info "Creating symlink for ssh confs"
  if "${IS_DARWIN}"; then
    ln -snfv "${SSH_CONFS_DIR_SRC_DARWIN}" "${SSH_CONFS_SYMLINK}"
  elif "${IS_LINUX}"; then
    ln -snfv "${SSH_CONFS_DIR_SRC_LINUX}" "${SSH_CONFS_SYMLINK}"
  fi
}

backup_vim() {
  title "Backup vim"
  local vim_dir="vim"

  backup_dir_file "${VIM_COLOR_DIR}" "${vim_dir}"
  backup_dir_file "${VIM_DIR_DEST}/.vimrc" "${vim_dir}"
  backup_dir_file "${VIM_INIT_SYMLINK}" "${vim_dir}"
  backup_dir_file "${VIM_PLUGIN_SYMLINK}" "${vim_dir}"
  backup_dir_file "${VIM_DEIN_PLUGINS_DIR_DEST}/plugins.toml" "${vim_dir}"
  backup_dir_file "${VIM_DEIN_PLUGINS_DIR_DEST}/plugins_lazy.toml" "${vim_dir}"
}

link_vim() {
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
    safety_remove "${VIM_INIT_SYMLINK}"
  fi
  info "Creating symlink for vimrc (init)"
  ln -snfv "${VIM_INIT_DIR_SRC}" "${VIM_INIT_SYMLINK}"

  if [ -e "${VIM_PLUGIN_SYMLINK}" ]; then
    safety_remove "${VIM_PLUGIN_SYMLINK}"
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

backup_tmux() {
  title "Backup tmux"
  local tmux_dir="tmux"

  backup_dir_file "${TMUX_DIR_DEST}/.tmux.conf" "${tmux_dir}"
  backup_dir_file "${TMUX_CONFS_SYMLINK}" "${tmux_dir}"
}

link_tmux() {
  title "Setup tmux"

  if [ ! -e "${TMUX_TPM_DIR}" ]; then
    info "Install tpm"
    git clone https://github.com/tmux-plugins/tpm "${TMUX_TPM_DIR}"
  fi

  info "Creating symlink for tmux"
  ln -snfv "${TMUX_DIR_SRC}/.tmux.conf" "${TMUX_DIR_DEST}/.tmux.conf"

  if [ -e "${TMUX_CONFS_SYMLINK}" ]; then
    safety_remove "${TMUX_CONFS_SYMLINK}"
  fi
  info "Creating symlink for tmux confs"
  ln -snfv "${TMUX_CONFS_DIR_SRC}" "${TMUX_CONFS_SYMLINK}"
}

backup_git() {
  title "Backup git"
  local git_dir="git"

  backup_dir_file "${GIT_CONF_DIR_DEST}/.gitconfig" "${git_dir}"
  backup_dir_file "${GIT_IGNORE_DIR_DEST}/.gitignore_global" "${git_dir}"
  backup_dir_file "${GIT_CONFS_SYMLINK}" "${git_dir}"
}

link_git() {
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
    safety_remove "${GIT_CONFS_SYMLINK}"
  fi
  info "Creating symlink for git confs"
  ln -snfv "${GIT_CONFS_DIR_SRC}" "${GIT_CONFS_SYMLINK}"
}

backup_peco() {
  title "Backup peco"
  local peco_dir

  backup_dir_file "${PECO_CONF_DIR_DEST}/config.json" "${peco_dir}"
}

link_peco() {
  title "Setup peco"

  info "Creating symlink for peco"
  if [ ! -e "${PECO_CONF_DIR_DEST}" ]; then
    info "Creating directory for peco conf"
    mkdir -p "${PECO_CONF_DIR_DEST}"
  fi
  ln -snfv "${PECO_CONF_DIR_SRC}/config.json" "${PECO_CONF_DIR_DEST}/config.json"
}

backup_dotfiles() {
  title "Backup dotfiles"
  
  if inquire "Backup dotfiles?"; then
    IS_WANTED_BACKUP=True
    backup_zsh
    backup_ssh
    backup_vim
    backup_tmux
    backup_git
    backup_peco
  else
    IS_WANTED_BACKUP=False
  fi
}

install_dotfiles() {
  link_zsh
  link_ssh
  link_vim
  link_tmux
  link_git
  link_peco
}

post_install_message() {
  title "Command to enable some package"
  
  info "For zsh, \"$ source ~/.zshrc\""
  info "For tmux, launch tmux then press \"Prefix + I\""
}

init
backup_dotfiles
download_dotfiles
setup_dotfiles_config
install_packages
change_shell
download_font
install_dotfiles
post_install_message

success "Install successful."

