case `uname` in
  Darwin)
    IS_OSX=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true
    IS_OSX=false
  ;;
esac

ZSH_CONF_DIR="${HOME}/.zsh.d"
ZSH_PRIORITIES_CONF="${ZSH_CONF_DIR}/priorities.conf"

for zsh_conf in ${ZSH_CONFS}; do
  source $zsh_conf
done
