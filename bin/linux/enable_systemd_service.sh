#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"

source "${DOTFILES_DIR}/bin/log.sh"

setup_service() {
  local DOTFILES_FETCH_SRC="${DOTFILES_DIR}/bin/dotfiles_fetch.sh"
  local DOTFILES_FETCH_DEST_DIR="/usr/local/bin"
  info "Creating symlink for dotfiles_fetch.sh"
  sudo ln -snvf ${DOTFILES_DIR}/bin/dotfiles_fetch.sh "${DOTFILES_FETCH_DEST_DIR}"
  local SERVICE_SRC_DIR="${DOTFILES_DIR}/etc/systemd"
  local SERVICE_DEST_DIR="${HOME}/.config/systemd/user"
  local FETCH_SERVICE_NAME="dotfiles-fetch.service"
  local FETCH_TIMER_NAME="dotfiles-fetch.timer"

  if [ ! -e "${SERVICE_DEST_DIR}" ]; then
    info "Creating ${SERVICE_DEST_DIR}"
    mkdir -p "${SERVICE_DEST_DIR}"
  fi

  info "Setting up timer service"
  info "Creating symlink for dotfiles-fetch"
  chmod 644 "${SERVICE_SRC_DIR}/${FETCH_TIMER_NAME}"
  chmod 644 "${SERVICE_SRC_DIR}/${FETCH_SERVICE_NAME}"
  systemctl link --user "${SERVICE_SRC_DIR}"/${FETCH_TIMER_NAME}
  systemctl link --user "${SERVICE_SRC_DIR}"/${FETCH_SERVICE_NAME}
  systemctl --user daemon-reload
  info "Enabling ${FETCH_TIMER_NAME}"
  systemctl --user enable "${FETCH_TIMER_NAME}"
  info "Starting ${FETCH_TIMER_NAME}"
  systemctl --user start "${FETCH_TIMER_NAME}"
}

setup_service

