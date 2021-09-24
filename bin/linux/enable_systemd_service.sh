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
  ln -snvf ${DOTFILES_DIR}/bin/dotfiles_fetch.sh "${DOTFILES_FETCH_DEST_DIR}"
  local SERVICE_SRC_DIR="${DOTFILES_DIR}/etc/systemd"
  local SERVICE_DEST_DIR="/usr/local/lib/systemd/system"

  if [ ! -e "${SERVICE_DEST_DIR}" ]; then
    info "Creating directory: ${SERVICE_DEST_DIR}"
    sudo mkdir -p "${SERVICE_DEST_DIR}"
  fi
 
  info "Setting up timer service"
  for service in ${SERVICE_SRC_DIR}/*.timer
  do
    local service_name="$(basename ${service})"
    info "Creating symlink for ${service_name}"
    sudo chmod 644 "${service}"
    ln -snfv "${service}" "${SERVICE_DEST_DIR}"/
    sudo systemctl daemon-reload
    info "Enabling ${service_name}"
    sudo systemctl enable "${SERVICE_DEST_DIR}/${service_name}"
    info "Starting ${service_name}"
    sudo systemctl start "${SERVICE_DEST_DIR}/${service_name}"
  done
}

init
setup_service

