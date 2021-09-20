#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_REMOTE_URL="https://github.com/narugit/dotfiles"

source "${DOTFILES_DIR}/bin/log.sh"

is_online() {
  local TEST_SERVER_URL="http://google.com"
  local RETRY_NUM=1
  local TIMEOUT_SEC=2
  http_proxy=${HTTP_PROXY} wget -q --tries="${RETRY_NUM}" --timeout="${TIMEOUT_SEC}" --spider "${TEST_SERVER_URL}"
  if [ "$?" = 0 ]; then
    true
  else
    false
  fi
}

is_hash_same() {
  local DOTFILES_DEFAULT_BRANCH=$(cd ${DOTFILES_DIR} && git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  local DOTFILES_REMOTE_HASH=$(cd ${DOTFILES_DIR} && git ls-remote origin HEAD | awk '{print $1}')
  local DOTFILES_LOCAL_HASH=$(cd ${DOTFILES_DIR} && git rev-parse ${DOTFILES_DEFAULT_BRANCH})
  if [ "${DOTFILES_LOCAL_HASH}" = "${DOTFILES_REMOTE_HASH}" ]; then
    true
  else
    false
  fi
}

title "Comparing remote dotfiles"
if is_online; then
  if is_hash_same; then
    info "Your local dotfiles is the latest!"
  else
    warning "Your local dotfiles differs from remote dotfiles. Please check ${DOTFILES_REMOTE_URL}"
  fi
else
  warning "Offline. Please check your internet connection. Do you set HTTP_PROXY?"
fi

