#!/bin/bash -eo pipefail
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"
DOTFILES_RAW_URL_PREFIX="https://raw.githubusercontent.com/narugit/dotfiles/master"
INSTALL_DEST="/usr/local/bin"

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

command_exists() {
  local command="$1"
  if which "$command" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

download_release() {
  local repo="$1"
  local release_file="$2"
  local url="https://github.com/${repo}/releases/latest/download/${release_file}"
  local downloaded_path="${DOTFILES_TMP_DIR}/${repo}"
  local downloaded_file="${downloaded_path}/$(basename ${url})"
  rm -rf "${downloaded_path}"
  mkdir -p "${downloaded_path}"
  curl -sL "${url}" -o "${downloaded_file}"
  echo ${downloaded_path}
}

install_aman() {
  local repo="naruhiyo/aman"
  local package_name="aman"
  local release_file="aman_linux_amd64.tar.gz"
  local downloaded_path=$(download_release "${repo}" "${release_file}")
  local downloaded_file="${downloaded_path}/${release_file}"
  if command_exists "${package_name}"; then
    info "Already installed ${package_name}"
  else
    info "Installing aman"
    (cd "${downloaded_path}" && tar -zxvf "${downloaded_file}" &> /dev/null)
    mv "${downloaded_path}/${package_name}" "${INSTALL_DEST}/${package_name}"
  fi
}

install_packages() {
  title "Installing GitHub release packages"

  install_aman
}


init
install_packages

