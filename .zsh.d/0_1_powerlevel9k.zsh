# ===============================================================
# - 色を確認する
#       $ GetColor [foreground | background]
#
# - 色を手軽に確認する
#       $ for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
#
# - アイコンを確認する
#       $ get_icon_names
#
# - カラースキーム
#       mbadolato/iTerm2-Color-Schemes/schemes/Galaxy.itermcolors
#
# - フォント
#       gabrielelana/awesome-terminal-fonts/patched/SourceCodePro+Powerline+Awesome+Regular.ttf
#
# ===============================================================

# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

# POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda virtualenv dir vcs)

# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time)

# POWERLEVEL9K_ANACONDA_LEFT_DELIMITER='(anaconda: '
# POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER=')'

# POWERLEVEL9K_VCS_GIT_ICON=''
# POWERLEVEL9K_VCS_UNTRACKED_ICON='+'
# POWERLEVEL9K_VCS_CLEAN_FOREGROUND='silver'
# POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='silver'
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="orange3"
# POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='silver'

# POWERLEVEL9K_DIR_HOME_FOREGROUND='silver'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='silver'
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='silver'
# POWERLEVEL9K_DIR_ETC_FOREGROUND='silver'

# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\n"
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%K{white}%F{015} $ %f%k%F{white}%f "
