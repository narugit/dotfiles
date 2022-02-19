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

has_package() {
  local package="$1"
  if brew list "$package" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

has_cask_package() {
  local package="$1"
  if brew list --cask "$package" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

install_homebrew() {
  title "Installing homebrew"
  if command_exists "brew"; then
    info "Already installed homebrew"
  else
    error "Command not found: brew. Please visit https://brew.sh/ and install homebrew."
  fi
}

install_packages() {
  title "Installing brew packages"
  pns=($(get_pns "darwin" "brew"))
  for v in ${pns[@]}
  do
    local package=$(echo $v | awk -F',' '{ print $1 }')
    if has_package "$package"; then
      info "Already installed ${package}"
    else
      info "Installing ${package}"
      brew install "${package}"
    fi
  done

  title "Installing brew tap packages"
  pn_repos=($(get_pn_any "${ABBREV_REPOSITORY}" "darwin" "brew_tap"))
  for v in ${pn_repos[@]}
  do
    local package=$(echo $v | awk -F',' '{ print $1 }')
    local repo=$(echo $v | awk -F',' '{ print $2 }')
    if has_package "$package"; then
      info "Already installed ${package}"
    else
      info "Installing ${package}"
      brew tap "${repo}"
      brew install "${package}"
    fi
  done

  title "Installing brew cask packages"
  pns=($(get_pns "darwin" "brew_cask"))
  for v in ${pns[@]}
  do
    local package=$(echo $v | awk -F',' '{ print $1 }')
    if has_cask_package "$package"; then
      info "Already installed ${package}"
    else
      info "Installing ${package}"
      brew install --cask "${package}"
    fi
  done
}

init
install_homebrew
install_packages

