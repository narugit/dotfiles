case `uname` in
  Darwin)
    IS_DARWIN=true
    IS_LINUX=false
  ;;
  Linux)
    IS_LINUX=true
    IS_DARWIN=false
  ;;
esac

ZSH_CONFS_DIR="${HOME}/.zsh.d"
ZSH_PRIORITIES_CONF="${ZSH_CONFS_DIR}/priorities.conf"

source "${ZSH_PRIORITIES_CONF}"

echo ${ZSH_CONFS_DIR}

for zsh_conf in ${ZSH_CONFS}; do
  source "${ZSH_CONFS_DIR}/${zsh_conf}"
done
