#!/bin/bash -ex

DOTFILES_DIR="${HOME}/dotfiles"

case $(uname) in
  Darwin)
    IS_DARWIN=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true
    IS_DARWIN=false
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
  info "Creating symlink for vim"
  ln -snfv "${VIM_DIR_SRC}/.vimrc" "${VIM_DIR_DEST}/.vimrc"

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

setup_dotfiles_sync_checker() {
  # register tracker for dotfiles modification
  title "Setup dotfiles sync checker"
}

download_dotfiles
change_shell
download_font
setup_zsh
setup_vim
setup_tmux
setup_dotfiles_sync_checker

success "Install successful."
