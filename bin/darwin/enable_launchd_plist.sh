#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"
DOTFILES_RAW_URL_PREFIX="https://raw.githubusercontent.com/narugit/dotfiles/master"

PLIST_LOG_DIR="/var/log/dotfiles"

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

  source_remote "bin/log.sh"
}

setup_plist() {
  title "Setup launchd plist"
  if [ ! -e "${PLIST_LOG_DIR}" ]; then
    info "Creating log directory: ${PLIST_LOG_DIR}"
    sudo mkdir -p "${PLIST_LOG_DIR}"
  fi
  
  sudo chmod 777 "${PLIST_LOG_DIR}"
  
  DOTFILES_FETCH_SRC="${DOTFILES_DIR}/bin/dotfiles_fetch.sh"
  DOTFILES_FETCH_DEST_DIR="/usr/local/bin"
  info "Creating symlink for dotfiles_fetch.sh"
  ln -snvf ${DOTFILES_DIR}/bin/dotfiles_fetch.sh "${DOTFILES_FETCH_DEST_DIR}"
  
  PLIST_SRC_DIR="${DOTFILES_DIR}/etc/launchd"
  PLIST_DEST_DIR="${HOME}/Library/LaunchAgents"
  PLIST_SYMLINK="${PLIST_DEST_DIR}/dotfiles"
  
  if [ ! -e "${PLIST_DEST_DIR}" ]; then
    info "Creating directory: "${PLIST_DEST_DIR}""
    mkdir -p "${PLIST_DEST_DIR}"
  fi
  
  info "Creating symlink for plists"
  ln -snfv "${PLIST_SRC_DIR}" "${PLIST_SYMLINK}"
  
  for plist in ${PLIST_SYMLINK}/*.plist
  do
    info "Loading plist: ${plist}"
    sudo chmod 644 "${plist}"
    launchctl unload "${plist}"
    launchctl load "${plist}"
  done
}

init
setup_plist

