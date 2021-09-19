set -g @plugin 'tmux-plugins/tpm'

set -g @plugin "tmux-plugins/tmux-battery"
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin "tmux-plugins/tmux-cpu"
set -g @plugin "tmux-plugins/tmux-prefix-highlight"
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-sensible'

if-shell '$IS_DARWIN' 'narugit/tmux-temp-mac' ''
set -g @plugin "samoshkin/tmux-plugin-sysstat"
