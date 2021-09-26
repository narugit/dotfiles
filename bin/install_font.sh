#!/bin/bash -eo pipefail
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"

source_remote "bin/log.sh"
source_remote "bin/check_os.sh"

command_exists() {
  local command="$1"
  if which "$command" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

get_latest_version() {
  local repo="$1"
  curl --silent "https://github.com/${repo}/releases/latest" | sed 's#.*tag/\(.*\)\".*#\1#'
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

font_exists() {
  local font="$1"
  local command="fc-list"
  if ! command_exists "${command}"; then
    error "command not exist: ${command}"
    exit 1
  fi
  if "${command}" | grep "$1" &> /dev/null; then
    true
  else
    false
  fi
}

install_cica() {
  local repo="miiton/Cica"
  local font_name="Cica"
  if font_exists "${font_name}"; then
    info "Already installed ${font_name} font."
  else
    info "Installing Cica"
    local latest_version="$(get_latest_version ${repo})"
    local release_file="Cica_${latest_version}_with_emoji.zip"
    local downloaded_path="$(download_release "${repo}" "${release_file}")"
    local downloaded_file="${downloaded_path}/${release_file}"
    (cd "${downloaded_path}" && unzip "${downloaded_file}" &> /dev/null)
    if "${IS_DARWIN}"; then
      local font_dest="${HOME}/Library/Fonts"
    elif "${IS_LINUX}"; then
      local font_dest="${HOME}/.local/share/fonts/"
    fi
    if [ ! -e "${font_dest}" ]; then
      mkdir -p "${font_dest}"
    fi
    mv "${downloaded_path}/${font_name}"*.ttf "${font_dest}/"
  fi
}

install_font() {
  title "Install font"
  install_cica
}

init
install_font

