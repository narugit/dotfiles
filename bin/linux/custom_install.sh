#!/bin/bash
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

  source_remote "bin/check_os.sh"
  source_remote "bin/log.sh"
  source_remote "bin/parse_packages.sh"
}

command_exists() {
  local command="$1"
  if which "$command" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

function_exists() {
  local function="$1"
  if type ${function} &>/dev/null; then
    true
  else
    false
  fi
}

install_rustup() {
  title "Install rustup"
  if command_exists "rustup"; then
    info "Already installed rustup"
  else
    info "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  fi
}

has_cargo_package() {
  local package="$1"
  if cargo install --list | grep "$package" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

cargo_install() {
  local package="$1"
  if has_cargo_package "$package"; then
    info "Already installed ${package}"
  else
    info "Installing ${package}"
    PATH="${HOME}/.cargo/bin:${PATH}" cargo install "${package}" 
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
  local package="$1"
  local command="$2"
  local repo="$3"
  local release_file="aman_linux_amd64.tar.gz"
  local downloaded_path=$(download_release "${repo}" "${release_file}")
  local downloaded_file="${downloaded_path}/${release_file}"
  if command_exists "${command}"; then
    info "Already installed ${package}"
  else
    info "Installing aman"
    (cd "${downloaded_path}" && tar -zxvf "${downloaded_file}" &> /dev/null)
    sudo mv "${downloaded_path}/${package}" "${INSTALL_DEST}/${package}"
  fi
}

install_git-delta() {
  local package="$1"
  cargo_install "${package}"
}

install_packages() {
  title "Install packages"

  pns=$(get_pns "linux" "custom")
  pn_repo=$(get_pn_any "${ABBREV_REPOSITORY}" "linux" "custom")
  pn_cmd=$(get_pn_any "${ABBREV_COMMAND}" "linux" "custom")
  for i in "${!pns[@]}"
  do
    local package=$(echo ${pns[$i]} | awk -F',' '{ print $1 }')
    local repository=$(echo ${pn_repo[$i]} | awk -F',' '{ print $2 }')
    local command=$(echo ${pn_cmd[$i]} | awk -F',' '{ print $2 }')
    if function_exists install_${package}; then
      install_${package} ${package} ${command} ${repository}
    else
      error "No install script for ${package}."
      exit 1
    fi
  done
}

init
if "${IS_LINUX}"; then
  install_rustup
  install_packages
fi

