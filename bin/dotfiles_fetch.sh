#!/bin/bash
set -o pipefail
DOTFILES_DIR="${HOME}/dotfiles"

log_print() {
  if [ -p /dev/stdin ]; then
    local arg=$(cat /dev/stdin)
  else
    local arg="$@"
  fi
  local file_name=${BASH_SOURCE[1]##*/}
  if [ -n "${arg}" ]; then
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') ${file_name} (${file_name}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $arg"
  fi
}

log_error() {
  if [ -p /dev/stdin ]; then
    local arg=$(cat /dev/stdin)
  else
    local arg="$@"
  fi
  local file_name=${BASH_SOURCE[1]##*/}
  if [ -n "${arg}" ]; then
    >&2 echo -e "$(date '+%Y-%m-%d %H:%M:%S') ${file_name} (${file_name}:${BASH_LINENO[0]}:${FUNCNAME[1]}) ERROR: $arg"
  fi
}

fetch_command() {
  (cd "${DOTFILES_DIR}" && git fetch -q origin master)
}

fetch() {
  (fetch_command | log_print) 2>&1 | log_error
  local ret="$?"
  if [ "$ret" = 0 ]; then
    log_print "Success to fetch."
  else
    log_error "Failed to fetch."
  fi
}

fetch

