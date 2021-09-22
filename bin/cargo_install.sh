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

command_exists() {
  local command="$1"
  if which "$command" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

install_rustup() {
  title "Install rustup"
  if command_exists "rustup"; then
    info "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  else
    info "Already installed rustup"
  fi
}

has_package() {
  local package="$1"
  if cargo install --list | grep "$package" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

install_packages() {
  title "Install packages"

  local PACKAGES=(
    "git-delta"
  )

  for package in "${PACKAGES[@]}"; do
    if has_package "$package"; then
      info "Already installed ${package}"
    else
      info "Installing ${package}"
      PATH="${HOME}/.cargo/bin:${PATH}" cargo install "${package}" 
    fi
  done
}

install_rustup
install_packages

