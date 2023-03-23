{}:
{
  enable = true;
  shortcut = "t";
  terminal = "screen-256color";
  keyMode = "vi";
  escapeTime = 0;
  extraConfig = ''
    # run nushell through fish (not as login shell)
    # to get necessary environment variables.
    # exec required to have new panes created in the current directory
    set -g default-command "exec nu"

    # navigate panes with alt-arrow
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Left select-pane -L
    bind -n M-Down select-pane -D

    # navigate tabs
    bind -n M-C-NPage next-window
    bind -n M-C-PPage previous-window

    # splits & tabs
    bind > split-window -h -c "#{pane_current_path}"
    bind v split-window -v -c "#{pane_current_path}"
    bind t new-window -c "#{pane_current_path}"
    # send pane to other existing window
    bind \" choose-window "join-pane -h -t '%%'"

    # vim-style copy-paste
    bind u copy-mode
    bind p paste-buffer
    bind -T copy-mode-vi v send-keys -X begin-selection
    bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    bind -T copy-mode-vi r send-keys -X rectangle-toggle
    # copy also to clipboard
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -sel clip -i"

    set -g mouse on
    set -g focus-events on

    # bells off
    set -g visual-activity off
    set -g visual-bell off
    set -g visual-silence off
    setw -g monitor-activity off
    set -g bell-action none

    # theming (only tmux-specific parts, rest done via kitty)

    # pane borders
    set -g pane-border-style 'fg=black'
    set -g pane-active-border-style 'fg=green'

    # statusbar
    set -g status-style 'bg=black fg=white'
    set -g status-left ""
    set -g status-right '%d.%m. %H:%M '
    set -g status-left-length 20
    setw -g window-status-style 'bg=black fg=white'
    setw -g window-status-current-style 'bg=green fg=black bold'
    setw -g window-status-format ' #I:#W#F '
    setw -g window-status-current-format ' #I:#W#F '
  '';
}
