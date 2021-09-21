#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_BIN_DIR="${DOTFILES_ETC_DIR}/bin"
DOTFILES_BIN_DARWIN_DIR="${DOTFILES_BIN_DIR}/bin/darwin"
DOTFILES_BIN_LINUX_DIR="${DOTFILES_BIN_DIR}/bin/linux"
DOTFILES_ETC_DIR="${DOTFILES_ETC_DIR}/etc"

GIT_CONF_DIR_SRC="${DOTFILES_ETC_DIR}/git"
GIT_CONF_DIR_DEST="${HOME}"
GIT_IGNORE_DIR_SRC="${DOTFILES_ETC_DIR}/git"
GIT_IGNORE_DIR_DEST="${HOME}"
GIT_CONFS_DIR_SRC="${DOTFILES_ETC_DIR}/git/.git.d"
GIT_CONFS_DIR_DEST="${HOME}"
GIT_CONFS_SYMLINK="${GIT_CONFS_DIR_DEST}/.git.d"

PECO_CONF_DIR_SRC="${DOTFILES_ETC_DIR}/peco"
PECO_CONF_DIR_DEST="${HOME}/.config/peco"

SSH_DIR_SRC="${DOTFILES_ETC_DIR}/ssh"
SSH_DIR_DEST="${HOME}/.ssh"
SSH_CONFS_DIR_SRC="${SSH_DIR_SRC}/.config.d"
SSH_CONFS_DIR_DEST="${SSH_DIR_DEST}"
SSH_CONFS_SYMLINK="${SSH_DIR_DEST}/.config.d"

TMUX_TPM_DIR="${HOME}/.tmux/plugins/tpm"
TMUX_DIR_SRC="${DOTFILES_ETC_DIR}/tmux"
TMUX_DIR_DEST="${HOME}"
TMUX_CONFS_DIR_SRC="${DOTFILES_ETC_DIR}/tmux/.tmux.d"
TMUX_CONFS_DIR_DEST="${HOME}"
TMUX_CONFS_SYMLINK="${TMUX_CONFS_DIR_DEST}/.tmux.d"

VIM_COLOR_DIR="${HOME}/.vim/colors"
VIM_DIR_SRC="${DOTFILES_ETC_DIR}/vim"
VIM_DIR_DEST="${HOME}"
VIM_DIR_SRC="${DOTFILES_ETC_DIR}/vim"
VIM_DIR_DEST="${HOME}"
VIM_PLUGIN_DIR_SRC="${DOTFILES_ETC_DIR}/vim/plugin"
VIM_PLUGIN_DIR_DEST="${HOME}/.vim"
VIM_PLUGIN_SYMLINK="${VIM_PLUGIN_DIR_DEST}/plugin"
VIM_DEIN_PLUGINS_DIR_SRC="${VIM_DIR_SRC}/dein"
VIM_DEIN_PLUGINS_DIR_DEST="${HOME}/.vim/dein/userconfig"

ZSH_DIR_SRC="${DOTFILES_ETC_DIR}/zsh"
ZSH_DIR_DEST="${HOME}"
ZSH_CONFS_DIR_SRC="${ZSH_DIR_SRC}/.zsh.d"
ZSH_CONFS_DIR_DEST="${HOME}"
ZSH_CONFS_SYMLINK="${ZSH_CONFS_DIR_DEST}/.zsh.d"
