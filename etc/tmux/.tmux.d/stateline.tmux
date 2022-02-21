set-option -g status-bg "colour244"
set-option -g status-fg "colour255"
set -g status-position top
set -g @cpu_percentage_format "%5.1f%%"
set-option -g status-interval 3
if-shell "uname | grep -q Darwin" \
  'set-option -g status-right "#{prefix_highlight} temp: #{temp_cpu} | CPU: #{cpu_percentage} | Storage: #{storage_status} | #{sysstat_mem} | #{battery_status_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %m/%d %H:%M#[default]"' \
  'set-option -g status-right "#{prefix_highlight} temp: #{temp_cpu} | CPU: #{cpu_percentage} | Storage: #{storage_status} | #{sysstat_mem} | %m/%d %H:%M#[default]"'
set -g @sysstat_mem_view_tmpl 'RAM: #[fg=#{colour255}]#{mem.used}/#{mem.total}'
set -g @storage_view_tmpl '(SSD)#[fg=#{colour255}] #{storage.used}/#{storage.total}'
set-window-option -g window-status-current-format "#[fg=colour255,bg=colour73,bold] #I: #W #[default]"
set -g @prefix_highlight_fg 'colour255' # default is 'colour231'
set -g @prefix_highlight_bg 'colour166'  # default is 'colour04'
set-option -g status-right-length 95
set -g status on
