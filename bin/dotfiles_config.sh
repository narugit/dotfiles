#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_BACKUP_DIR="${HOME}/dotfiles.bk"
DOTFILES_BIN_DIR="${DOTFILES_DIR}/bin"
DOTFILES_BIN_DARWIN_DIR="${DOTFILES_BIN_DIR}/darwin"
DOTFILES_BIN_LINUX_DIR="${DOTFILES_BIN_DIR}/linux"
DOTFILES_ETC_DIR="${DOTFILES_DIR}/etc"

# ====== git ======
# ${HOME}/
#     |- .gitconfig -> dotfiles/etc/git/.gitconfig
#     |- .gitignore_global -> dotfiles/etc/git/.gitignore_global_[darwin|linux]
#     |- .git.d/ -> dotfiles/etc/git/.git.d
#     `- dotfiles/
#         `- etc/
#             `- git/
#                 |- .gitconfig
#                 |- .gitignore_global_darwin
#                 |- .gitignore_global_linux
#                 `- .git.d/
GIT_CONF_DIR_SRC="${DOTFILES_ETC_DIR}/git"
GIT_CONF_DIR_DEST="${HOME}"
GIT_IGNORE_DIR_SRC="${DOTFILES_ETC_DIR}/git"
GIT_IGNORE_DIR_DEST="${HOME}"
GIT_CONFS_DIR_SRC="${DOTFILES_ETC_DIR}/git/.git.d"
GIT_CONFS_DIR_DEST="${HOME}"
GIT_CONFS_SYMLINK="${GIT_CONFS_DIR_DEST}/.git.d"

# ====== peco ======
# ${HOME}/
#     |- .config/
#         `- peco/
#             `- config.json -> dotfiles/etc/peco/config.json
#     `- dotfiles/
#         `- etc/
#             `- peco/
#                 `- config.json
PECO_CONF_DIR_SRC="${DOTFILES_ETC_DIR}/peco"
PECO_CONF_DIR_DEST="${HOME}/.config/peco"

# ====== ssh ======
# ${HOME}/
#     |- .ssh
#         |- .config.d/ -> dotfiles/etc/ssh/.config.d/[darwin|linux]
#     `- dotfiles/
#         `- etc/
#             `- ssh/
#                 `- .config.d/
#                     |- darwin/
#                     `- linux/
SSH_DIR_SRC="${DOTFILES_ETC_DIR}/ssh"
SSH_DIR_DEST="${HOME}/.ssh"
SSH_CONFS_DIR_SRC_DARWIN="${SSH_DIR_SRC}/.config.d/darwin"
SSH_CONFS_DIR_SRC_LINUX="${SSH_DIR_SRC}/.config.d/linux"
SSH_CONFS_DIR_DEST="${SSH_DIR_DEST}"
SSH_CONFS_SYMLINK="${SSH_DIR_DEST}/.config.d"

# ====== tmux ======
# ${HOME}/
#     |- .tmux.conf -> dotfiles/etc/tmux/.tmux.conf
#     |- .tmux.d/ -> dotfiles/etc/tmux/.tmux.d
#     `- dotfiles/
#         `- etc/
#             `- tmux/
#                 |- .tmux.conf
#                 `- .tmux.d/
TMUX_TPM_DIR="${HOME}/.tmux/plugins/tpm"
TMUX_DIR_SRC="${DOTFILES_ETC_DIR}/tmux"
TMUX_DIR_DEST="${HOME}"
TMUX_CONFS_DIR_SRC="${DOTFILES_ETC_DIR}/tmux/.tmux.d"
TMUX_CONFS_DIR_DEST="${HOME}"
TMUX_CONFS_SYMLINK="${TMUX_CONFS_DIR_DEST}/.tmux.d"

# ====== vim ======
# ${HOME}/
#     |- .vimrc -> dotfiles/etc/vim/.vimrc
#     |- .vim/
#         |- dein
#             |- userconfig/
#                 |- plugins.toml -> dotfiles/etc/vim/dein/plugins.toml
#                 `- plugins_lazy.toml -> dotfiles/etc/vim/dein/plugins_lazy.toml
#         |- init/ -> dotfiles/etc/vim/init
#         `- plugin/ -> dotfiles/etc/vim/plugin
#     `- dotfiles/
#         `- etc/
#             `- vim/
#                 |- .vimrc
#                 |- dein/
#                     |- plugins.toml
#                     `- plugins_lazy.toml
#                 |- init/
#                 `- plugin/
VIM_COLOR_DIR="${HOME}/.vim/colors"
VIM_DIR_SRC="${DOTFILES_ETC_DIR}/vim"
VIM_DIR_DEST="${HOME}"
VIM_DIR_SRC="${DOTFILES_ETC_DIR}/vim"
VIM_DIR_DEST="${HOME}"
VIM_INIT_DIR_SRC="${DOTFILES_ETC_DIR}/vim/init"
VIM_INIT_DIR_DEST="${HOME}/.vim"
VIM_INIT_SYMLINK="${VIM_INIT_DIR_DEST}/init"
VIM_PLUGIN_DIR_SRC="${DOTFILES_ETC_DIR}/vim/plugin"
VIM_PLUGIN_DIR_DEST="${HOME}/.vim"
VIM_PLUGIN_SYMLINK="${VIM_PLUGIN_DIR_DEST}/plugin"
VIM_DEIN_PLUGINS_DIR_SRC="${VIM_DIR_SRC}/dein"
VIM_DEIN_PLUGINS_DIR_DEST="${HOME}/.vim/dein/userconfig"

# ====== zsh ======
# ${HOME}/
#     |- .zshrc -> dotfiles/etc/zsh/.zshrc
#     |- .zsh.d/ -> dotfiles/etc/zsh/.zsh.d
#     `- dotfiles/
#         `- etc/
#             `- zsh/
#                 |- .zshrc
#                 `- .zsh.d/
ZSH_DIR_SRC="${DOTFILES_ETC_DIR}/zsh"
ZSH_DIR_DEST="${HOME}"
ZSH_CONFS_DIR_SRC="${ZSH_DIR_SRC}/.zsh.d"
ZSH_CONFS_DIR_DEST="${HOME}"
ZSH_CONFS_SYMLINK="${ZSH_CONFS_DIR_DEST}/.zsh.d"
