#!/bin/bash
DOTFILES_DIR="${HOME}/dotfiles"
source "${DOTFILES_DIR}/bin/log.sh"

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
    info "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_packages() {
  title "Installing packages"

  local PACKAGES=(
    "aman"
    "aria2"
    "atool"
    "bat"
    "cmake"
    "ffmpeg"
    "git"
    "jq"
    "peco"
    "python3"
    "tmux"
    "tree"
    "wget"
    "youtube-dl"
  )

  local TAPS=(
    "naruhiyo/aman"
  )

  local CASK_PACKAGES=(
    "discord"
    "font-hack-nerd-font"
    "google-chrome"
    "iterm2"
    "skype"
    "slack"
    "spectacle"
    "visual-studio-code"
  )

  for package in "${PACKAGES[@]}"; do
    if has_package "$package"; then
      info "Already installed ${package}"
    else
      info "Installing ${package}"
      brew install "${package}"
    fi
  done

  title "Installing cask packages"

  for package in "${CASK_PACKAGES[@]}"; do
    if has_cask_package "$package"; then
      info "Already installed ${package}"
    else
      info "Installing ${package}"
      brew install --cask "${package}"
    fi
  done
}

install_homebrew
install_packages

