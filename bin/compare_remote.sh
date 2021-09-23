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

  if [ -z "${DOTFILES_REMOTE_HASH}" ]; then
    error "Please set ${HOME}/.ssh/id_rsa_personal"
    false
  else
    if [ "${DOTFILES_LOCAL_HASH}" = "${DOTFILES_REMOTE_HASH}" ]; then
      true
    else
      false
    fi
  fi
}

is_local_clean() {
  if [ -z "$(git status --porcelain)" ]; then
    true
  else
    false
  fi
}

title "Comparing remote dotfiles"
if is_online; then
  if is_hash_same && is_local_clean; then
    success "Your local dotfiles is up to date!"
  else
    warning "Your local dotfiles differs from remote dotfiles. Please check ${DOTFILES_DIR} and ${DOTFILES_REMOTE_URL}"
  fi
else
  warning "Offline. Please check your internet connection. Do you set HTTP_PROXY?"
fi

