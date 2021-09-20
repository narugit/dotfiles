DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_REMOTE_URL="https://github.com/narugit/dotfiles"

source "${DOTFILES_DIR}/bin/log.sh"

ACTIVE_HOUR_START=10
ACTIVE_HOUR_END=17

# rarity: one time in how many times to compare with remote's dotfiles.
RARITY_MIN=1
RARITY_ACTIVE_HOUR=10
RARITY_NON_ACTIVE_HOUR=1

generate_random() {
  local min="$1"
  local max="$2"
  local random_num=$(awk -v min="$min" -v max="$max" 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
  echo "$random_num"
}

is_online() {
  local TEST_SERVER_URL="http://google.com"
  local RETRY_NUM=10
  local TIMEOUT_SEC=20
  wget -q --tries="${RETRY_NUM}" --timeout="${TIMEOUT_SEC}" --spider "${TEST_SERVER_URL}"
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

is_active_hour() {
  current_hour=$(date +"%H")
  if [ ${ACTIVE_HOUR_START} -le ${current_hour} ] && [ ${current_hour} -lt ${ACTIVE_HOUR_END} ]; then
    true
  else
    false
  fi
}


check_rarity() {
  if [ ${RARITY_ACTIVE_HOUR} -lt ${RARITY_MIN} ]; then
    error "RARITY_ACTIVE_HOUR should be greater than ${RARITY_MIN}."
  fi
  if [ ${RARITY_NON_ACTIVE_HOUR} -lt ${RARITY_MIN} ]; then
    error "RARITY_NON_ACTIVE_HOUR should be greater than ${RARITY_MIN}."
  fi

  if is_active_hour; then
    echo ${RARITY_ACTIVE_HOUR}
  else
    echo ${RARITY_NON_ACTIVE_HOUR}
  fi
}

lottery_to_compare() {
  rarity=$(check_rarity)
  num=$(generate_random ${RARITY_MIN} $rarity)

  if [ $num = ${RARITY_MIN} ]; then
    true
  else
    false
  fi
}


if lottery_to_compare; then
  title "Comparing remote dotfiles"
  if is_online; then
    if is_hash_same; then
      info "Your local dotfiles is the latest!"
    else
      warning "Your local dotfiles differs from remote dotfiles. Please check ${DOTFILES_REMOTE_URL}"
    fi
  else
    warning "Offline. Please check your internet connection."
  fi
fi

