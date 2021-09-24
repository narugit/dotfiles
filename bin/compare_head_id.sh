#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_REMOTE_URL="https://github.com/narugit/dotfiles"

source "${DOTFILES_DIR}/bin/log.sh"

is_hash_same() {
  local DOTFILES_DEFAULT_BRANCH="master"
  local DOTFILES_REMOTE_HASH=$(cd ${DOTFILES_DIR} && git rev-parse origin/${DOTFILES_DEFAULT_BRANCH})
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
if is_hash_same && is_local_clean; then
  success "Your local dotfiles may be up to date at least in a hour!"
else
  warning "Your local dotfiles differs from remote dotfiles. Please check ${DOTFILES_DIR} and ${DOTFILES_REMOTE_URL}"
fi

