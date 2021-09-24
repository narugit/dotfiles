DOTFILES_DIR="${HOME}/dotfiles"
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
  source "${DOTFILES_DIR}/bin/compare_head_id.sh"
fi

