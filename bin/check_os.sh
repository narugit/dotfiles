#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"
DOTFILES_RAW_URL_PREFIX="https://raw.githubusercontent.com/narugit/dotfiles/master"
INSTALL_DEST="/usr/local/bin"

DARWIN_REQUIRE_MAJOR_VERSION="11"
UBUNTU_REQUIRE_MAJOR_VERSION="20"

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

check_os() {
  case $(uname) in
    Darwin)
      IS_DARWIN=true
      IS_LINUX=false
    ;;
    Linux)
      local info_file="/etc/lsb-release"
      if [ -e "${info_file}" ]; then
        local os_name="$(source ${info_file} && echo ${DISTRIB_ID})"
        if [ "${os_name}" != "Ubuntu" ]; then
          error "Not supported OS."
          exit 1
        fi
      fi
      IS_LINUX=true
      IS_DARWIN=false
    ;;
    *)
      IS_LINUX=false
      IS_DARWIN=false
      error "Not supoorted OS."
      exit 1
    ;;
  esac
}

is_number() {
  local num="$1"
  local re='^[0-9]+$'
  if [[ "${num}" =~ $re ]]; then
    true
  else
    false
  fi
}

check_osversion() {
  if "${IS_LINUX}"; then
    local info_file="/etc/lsb-release"
    if [ -e "${info_file}" ]; then
      local os_version="$(source ${info_file} && echo $DISTRIB_RELEASE)"
      local os_major_version="$(echo ${os_version} | awk -F '.' '{ print $1 }')"
      if is_number "${os_major_version}"; then
        if [ "${os_major_version}" -lt "${UBUNTU_REQUIRE_MAJOR_VERSION}" ]; then
          error "Not supported OS version. Require major version is ${UBUNTU_REQUIRE_MAJOR_VERSION}<="
          exit 1
        fi
      fi
    else
      error "Not supported OS version. ${info_file}: No such file or directory"
      exit 2
    fi
  elif "${IS_DARWIN}"; then
    local command="sw_vers"
    if command_exists "${command}"; then
      local os_version="$(${command} | grep 'ProductVersion' | awk '{ print $2 }')"
      local os_major_version="$(echo ${os_version} | awk -F '.' '{ print $1 }')"
      local require_major_version="11"
      if is_number "${os_major_version}"; then
        if [ "${os_major_version}" -lt "${DARWIN_REQUIRE_MAJOR_VERSION}" ]; then
          error "Not supported OS version. Require major version is ${DARWIN_REQUIRE_MAJOR_VERSION}<="
          exit 1
        fi
      fi
    else
      error "Not supported OS version. Command not found: ${command}"
      exit 1
    fi
  else
    error "Not supported OS."
    exit 1
  fi
}

init
check_os
check_osversion

