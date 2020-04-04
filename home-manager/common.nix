{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  programs = {
    git = {
      enable = true;
      userName = "Mikael Myyrä";
      userEmail = "mikael.myyrae@gmail.com";
      ignores = [
        "*.nogit*"
        ".envrc"
      ];
    };
    fish = {
      enable = true;
      shellAbbrs = {
        ls = "lsd";
        l = "lsd -al";
        ll = "lsd -l";
        tree = "lsd --tree";
        ga = "git add"; 
        gc = "git commit -v";
        "gc!" = "git commit -v --amend";
        gl = "git pull";
        gf = "git fetch";
        gco = "git checkout";
        gd = "git diff";
        gsh = "git show";
        gst = "git status";
        gb = "git branch";
        gsta = "git stash";
        gstp = "git stash pop";
        glg = "git log --stat";
        glga = "git log --stat --graph --all";
        glo = "git log --oneline";
        gloa = "git log --oneline --graph --all";
        grh = "git reset HEAD";
      };
    };
    starship = {
      enable = true;
      settings = {
        prompt_order = [
          "username" "hostname" "directory"
          "git_branch" "git_state" "git_status"
          "package" "nodejs" "ruby"
          "rust" "python" "golang" "cmd_duration"
          "line_break"
          "jobs" "battery" "nix_shell" "character"
        ];
        cmd_duration.min_time = 1;
        directory.fish_style_pwd_dir_length = 1;
        git_status = {
          show_sync_count = true;
          modified = "*";
        };
        nix_shell = {
          impure_msg = "λ";
          pure_msg = "λλ";
        };
        rust.disabled = true;
        golang.disabled = true;
        ruby.disabled = true;
        nodejs.disabled = true;
        python.disabled = true;
      };
    };
    tmux = {
      enable = true;
      shortcut = "t";
      terminal = "screen-256color";
      keyMode = "vi";
      escapeTime = 0;
      extraConfig = ''
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
        bind w kill-window

        # vim-style copy-paste
        bind u copy-mode
        bind p paste-buffer
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind -T copy-mode-vi r send-keys -X rectangle-toggle
        # copy also to clipboard
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -sel clip -i"

        set -g mouse on

        # bells off
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none

        # panes and borders
        set -g pane-border-style 'bg=colour0 fg=colour10'
        set -g pane-active-border-style 'bg=colour0 fg=colour10'
        set -g window-style 'bg=colour8 fg=colour242'
        set -g window-active-style 'bg=colour8 fg=colour12'

        # statusbar
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'bg=colour0 fg=colour2 dim'
        set -g status-left ""
        set -g status-right '#[fg=colour255,bg=colour0]%d.%m. #[fg=colour255,bg=colour0]%H:%M '
        set -g status-right-length 50
        set -g status-left-length 20

        setw -g window-status-current-style 'fg=colour233 bg=colour2 bold'
        setw -g window-status-current-format ' #I#[fg=colour233]:#[fg=colour233]#W#[fg=colour233]#F '

        setw -g window-status-style 'fg=colour255 bg=colour0'
        setw -g window-status-format ' #I#[fg=colour255]:#[fg=colour255]#W#[fg=colour255]#F '

        # messages
        set -g message-style 'fg=colour0 bg=colour6 bold'
      '';
    };
    firefox = {
      enable = true;
      package = (pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.passff-host ];});
    };
    z-lua.enable = true;
    fzf.enable = true;
    feh.enable = true;
    direnv.enable = true;
    home-manager.enable = true;
  };
  
  services = {
    lorri.enable = true;
    picom = {
      enable = true;
      shadow = true;
      shadowOpacity = "0.5";
      shadowOffsets = [ (-5) (-5) ];
      fade = true;
      fadeDelta = 4;
      blur = true;
      inactiveOpacity = "0.90";
      opacityRule = [
        # Opaque at all times
        "100:class_g = 'Firefox'"
        "100:class_g = 'feh'"
        "100:class_g = 'vlc'"
        "100:class_g = 'obs'"
        # Slightly transparent even when focused
        "95:class_g = 'VSCodium' && focused"
        "95:class_g = 'discord' && focused"
        "95:class_g = 'Spotify' && focused"
        "95:class_g = 'kitty' && focused"
      ];
    };
  };

  # extra stuff not in programs and/or config files managed manually
  home.packages = with pkgs; [
    # cli/dev utils
    kitty
    lsd
    tokei
    ripgrep
    xclip
    vscodium
    niv
    # general helpful stuff
    pass
    stretchly
    redshift
    networkmanagerapplet
    # multimedia
    maim
    vlc
    xbindkeys
    xdotool
    pcmanfm
  ];
  home.file = {
    "awesome" = {
      source = ../awesome;
      target = "./.config/awesome";
    };
    "kitty.conf" = {
      source = ../kitty;
      target = "./.config/kitty";
    };
    # home-manager has redshift but does not support constant activation times
    "redshift.conf" = {
      source = ../redshift.conf;
      target = "./.config/redshift.conf";
    };
    # trackball customization
    "xprofile" = {
      source = ../.xprofile;
      target = "./.xprofile";
    };
    "xbindkeysrc" = {
      source = ../.xbindkeysrc;
      target = "./.xbindkeysrc";
    };
  };
  
  xsession = {
    windowManager.awesome.enable = true;
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Ice";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
