#!/bin/bash
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

  source_remote "bin/log.sh"
}

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

init
setup_service

