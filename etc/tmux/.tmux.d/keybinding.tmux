set -g prefix C-space
bind-key C-a send-prefix
unbind-key C-b

bind r source-file ~/.tmux.conf \; display-message "Config reloaded..."

bind-key / split-window -h -c '#{pane_current_path}'
bind-key - split-window -v -c '#{pane_current_path}'

bind-key -n C-Tab next-window
bind-key -n C-S-Tab previous-window

set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xsel -bi"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xsel -bi"

# toggle to synchronize command in all panes
bind-key a setw synchronize-panes \; display "synchronize-panes #{?pane_synchronized,on,off}"

bind-key h select-pane -L
bind-key j select-pane -D
bind-key l select-pane -R
bind-key k select-pane -U
