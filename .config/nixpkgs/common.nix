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
        ".direnv"
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
    firefox.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    feh.enable = true;
    direnv.enable = true;
    home-manager.enable = true;
  };
  
  services = {
    lorri.enable = true;
    compton = {
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
    kitty
    tmux
    xbindkeys
    vscodium
    lsd
    tokei
    ripgrep
    xclip
    maim
    pass
    stretchly
    redshift
    vlc
    networkmanagerapplet
  ];
  home.file = {
    "awesome" = {
      source = ../awesome;
      target = "./.config/awesome";
    };
    ".tmux.conf" = {
      source = ../../.tmux.conf;
      target = "./.tmux.conf";
    };
    "kitty.conf" = {
      source = ../kitty;
      target = "./.config/kitty";
    };
    "code/settings.json" = {
      source = ../../vscode/settings.json;
      target = "./.config/VSCodium/User/settings.json";
    };
    "code/keybindings.json" = {
      source = ../../vscode/keybindings.json;
      target = "./.config/VSCodium/User/keybindings.json";
    };
    # home-manager has redshift but does not support constant activation times
    "redshift.conf" = {
      source = ../redshift.conf;
      target = "./.config/redshift.conf";
    };
    # trackball customization
    "xprofile" = {
      source = ../../.xprofile;
      target = "./.xprofile";
    };
    "xbindkeysrc" = {
      source = ../../.xbindkeysrc;
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
