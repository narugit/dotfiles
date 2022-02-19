#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"

PLIST_LOG_DIR="/var/log/dotfiles"

source "${DOTFILES_DIR}/bin/log.sh"

setup_plist() {
  info "Setup launchd plist"
  if [ ! -e "${PLIST_LOG_DIR}" ]; then
    info "Creating log directory: ${PLIST_LOG_DIR}"
    sudo mkdir -p "${PLIST_LOG_DIR}"
  fi
  
  sudo chmod 777 "${PLIST_LOG_DIR}"
  
  DOTFILES_FETCH_SRC="${DOTFILES_DIR}/bin/dotfiles_fetch.sh"
  DOTFILES_FETCH_DEST_DIR="/usr/local/bin"
  info "Creating symlink for dotfiles_fetch.sh"
  sudo ln -snvf ${DOTFILES_DIR}/bin/dotfiles_fetch.sh "${DOTFILES_FETCH_DEST_DIR}"
  
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
    launchctl unload "${plist}" &> /dev/null
    launchctl load "${plist}"
  done
}

setup_plist

