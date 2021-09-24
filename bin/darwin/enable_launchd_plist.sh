#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
PLIST_LOG_DIR="/var/log/dotfiles"

if [ ! -e "${PLIST_LOG_DIR}" ]; then
  sudo mkdir -p "${PLIST_LOG_DIR}"
fi

sudo chmod 777 "${PLIST_LOG_DIR}"

DOTFILES_FETCH_SRC="${DOTFILES_DIR}/bin/dotfiles_fetch.sh"
DOTFILES_FETCH_DEST_DIR="/usr/local/bin"
ln -snvf ${DOTFILES_DIR}/bin/dotfiles_fetch.sh "${DOTFILES_FETCH_DEST_DIR}"

PLIST_SRC_DIR="${DOTFILES_DIR}/etc/launchd"
PLIST_DEST_DIR="${HOME}/Library/LaunchAgents"
PLIST_SYMLINK="${PLIST_DEST_DIR}/dotfiles"

if [ ! -e "${PLIST_DEST_DIR}" ]; then
  mkdir -p "${PLIST_DEST_DIR}"
fi

ln -snfv "${PLIST_SRC_DIR}" "${PLIST_SYMLINK}"

for plist in ${PLIST_SYMLINK}/*.plist
do
  sudo chmod 644 "${plist}"
  launchctl unload "${plist}"
  launchctl load "${plist}"
done

