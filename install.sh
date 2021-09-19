#!/bin/bash -ex

DOTFILES_DIR="${HOME}/dotfiles"

case $(uname) in
  Darwin)
    IS_DARWIN=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true IS_DARWIN=false
  ;;
esac

COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

title() {
  echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

download_dotfiles() {
  title "Downloading narugit/dotfiles"
  if [ -e "${DOTFILES_DIR}" ]; then
    warning "Remove ${DOTFILES_DIR}?"
    read -p "(y/N): " yn
    case "$yn" in
      [yY]*)
        rm -rf "${DOTFILES_DIR}"
        ;;
      *)
        error "Abort. You need to remove ${DOTFILES_DIR}"
        exit 1;;
    esac
  fi
  git clone https://github.com/narugit/dotfiles.git "${DOTFILES_DIR}"
  (cd "${DOTFILES_DIR}"; git remote set-url origin git@github.com:narugit/dotfiles.git)
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
  local ZSH_CONFS_DIR_SRC="${ZSH_DIR_SRC}/.zsh.d"
  local ZSH_CONFS_DIR_DEST="${HOME}/.zsh.d"
  info "Creating symlink for zshrc"
  ln -snfv "${ZSH_DIR_SRC}/.zshrc" "${ZSH_DIR_DEST}/.zshrc"
  if [ ! -e "${ZSH_CONFS_DIR_DEST}" ]; then
    info "Creating directory for zshrcs"
    mkdir -p "${ZSH_CONFS_DIR_DEST}"
  fi
  ln -snfv "${ZSH_CONFS_DIR_SRC}"/* "${ZSH_CONFS_DIR_DEST}"
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
  local VIM_INIT_DIR_DEST="${HOME}/.vim/init"
  if [ ! -e "${VIM_INIT_DIR_DEST}" ]; then
    info "Creating directory for vimrc (init)"
    mkdir -p "${VIM_INIT_DIR_DEST}"
  fi
  info "Creating symlink for vimrc (init)"
  ln -snfv "${VIM_INIT_DIR_SRC}"/*.vim "${VIM_INIT_DIR_DEST}"

  local VIM_PLUGIN_DIR_SRC="${DOTFILES_DIR}/etc/vim/plugin"
  local VIM_PLUGIN_DIR_DEST="${HOME}/.vim/plugin"
  if [ ! -e "${VIM_PLUGIN_DIR_DEST}" ]; then
    info "Creating directory for vimrc (plugin)"
    mkdir -p "${VIM_PLUGIN_DIR_DEST}"
  fi
  info "Creating symlink for vimrc (plugin)"
  ln -snfv "${VIM_PLUGIN_DIR_SRC}"/*.vim "${VIM_PLUGIN_DIR_DEST}"

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
  local TMUX_CONFS_DIR_SRC="${DOTFILES_DIR}/etc/tmux/.tmux.d"
  local TMUX_CONFS_DIR_DEST="${HOME}/.tmux.d"
  info "Creating symlink for tmux"
  ln -snfv "${TMUX_DIR_SRC}/.tmux.conf" "${TMUX_DIR_DEST}/.tmux.conf"
  if [ ! -e "${TMUX_CONFS_DIR_DEST}" ]; then
    info "Creating directory for tmux confs"
    mkdir -p "${TMUX_CONFS_DIR_DEST}"
  fi
  ln -snfv "${TMUX_CONFS_DIR_SRC}"/*.tmux "${TMUX_CONFS_DIR_DEST}"
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
  elif "${IS_LINIX}"; then
    ln -snfv "${GITIGNORE_DIR_SRC}/.gitignore_global_linux" "${GITIGNORE_DIR_DEST}/.gitignore_global"
  fi

  local GIT_CONFS_DIR_SRC="${DOTFILES_DIR}/etc/git/.git.d"
  local GIT_CONFS_DIR_DEST="${HOME}/.git.d"
  if [ ! -e "${GIT_CONFS_DIR_DEST}" ]; then
    info "Creating directory for git conf"
    mkdir -p "${GIT_CONFS_DIR_DEST}"
  fi
  info "Creating symlink for git confs"
  ln -snfv "${GIT_CONFS_DIR_SRC}"/*.git "${GIT_CONFS_DIR_DEST}"
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
change_shell
download_font
setup_zsh
setup_vim
setup_tmux
setup_git
setup_peco
setup_dotfiles_sync_checker
post_install_message

success "Install successful."
