#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_TMP_DIR="/tmp/dotfiles"
DOTFILES_RAW_URL_PREFIX="https://raw.githubusercontent.com/narugit/dotfiles/master"

COL_HEAD="package name"
COL_COMMAND="command"
COL_REPOSITORY="repository"
COL_INSTALL_BY="install by"
COL_OS="os"
ABBREV_PACKAGE_NAME="pn"
ABBREV_COMMAND="cmd"
ABBREV_REPOSITORY="repo"
ABBREV_INSTALL_BY="inst_by"
ABBREV_OS="os"
CSV_URL="${DOTFILES_RAW_URL_PREFIX}/data/packages.csv"
CSV_DIR="${DOTFILES_TMP_DIR}/data"
CSV="${CSV_DIR}/packages.csv"

download_csv() {
  if [ ! -e "${CSV_DIR}" ]; then
    mkdir -p "${CSV_DIR}"
  fi
  curl -fsL "${CSV_URL}" -o "${CSV}"
}

get_index_from_col() {
  local col="$1"
  head -1 "${CSV}" | tr ',' '\n' | nl | grep -w "${col}" | tr -d " " | awk -F " " '{print $1}'
}

# Get "package name,any" from "os" and "install by".
# If you use same combination of "os" and "install by", you will get same row's array
get_pn_any() {
  local any="v_$1"
  local os="$2"
  local install_by="$3"
  local loc_col_head=$(get_index_from_col "${COL_HEAD}") 
  local loc_col_command=$(get_index_from_col "${COL_COMMAND}") 
  local loc_col_repository=$(get_index_from_col "${COL_REPOSITORY}") 
  local loc_col_install_by=$(get_index_from_col "${COL_INSTALL_BY}") 
  local loc_col_os=$(get_index_from_col "${COL_OS}") 
  local values=()
  while IFS="," read -r v_pn v_cmd v_repo v_install_by v_os
  do
    if echo "${v_os}${v_install_by}" | grep -x "${os}${install_by}" &> /dev/null; then
      values+=("${v_pn},${!any}")
    fi
  done < <(cut -d "," -f${loc_col_head},${loc_col_command},${loc_col_repository},${loc_col_install_by},${loc_col_os} "${CSV}" | tail -n +2)
  echo ${values[@]}
}

download_csv
