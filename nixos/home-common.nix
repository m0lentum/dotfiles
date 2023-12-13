{ config, pkgs, ... }:

let
  # directories to ignore in tree and fzf listings because they're
  # never what I'm looking for and make lists too big to navigate
  listIgnores = [
    ".git"
    "node_modules"
    "build"
    "target"
    "__pycache__"
    ".cache"
    ".pytest_cache"
    ".mypy_cache"
  ];

  shells = import ./home-modules/shells.nix { inherit pkgs listIgnores; };
in
{
  nixpkgs.config.allowUnfree = true;
  programs = {
    git = import ./home-modules/git.nix { inherit pkgs; };
    fish = shells.fish;
    nushell = shells.nushell;
    starship = import ./home-modules/starship.nix { inherit pkgs; };
    kitty = import ./home-modules/kitty.nix { inherit pkgs; };
    tmux = import ./home-modules/tmux.nix { };
    nnn = import ./home-modules/nnn.nix { inherit pkgs; };
    neovim = import ./home-modules/neovim.nix { inherit pkgs listIgnores; };
    helix = {
      enable = true;
      settings = {
        editor = {
          scrolloff = 15;
          line-number = "relative";
          bufferline = "always";
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          indent-guides.render = true;
        };
      };
    };
    firefox = {
      enable = true;
      package = (pkgs.firefox.override { nativeMessagingHosts = [ pkgs.passff-host ]; });
    };
    fzf = {
      enable = true;
      defaultCommand = pkgs.lib.strings.concatStrings (
        [ "rg --files --follow --no-ignore-vcs --hidden -g '!{" ]
        ++ (pkgs.lib.strings.intersperse "," (map (i: "**/" + i + "/*") listIgnores))
        ++ [ "}'" ]
      );
    };
    zathura.enable = true;
    zoxide.enable = true;
    lsd.enable = true;
    feh.enable = true;
    direnv.enable = true;
    home-manager.enable = true;
    nix-index.enable = true;
  };

  services = {
    lorri.enable = true;
    picom = import ./home-modules/picom.nix { };
    unclutter.enable = true;
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 5000;
      };
      latitude = "62.24";
      longitude = "25.70";
    };
  };

  # extra stuff not in programs and/or config files managed manually
  home.packages = with pkgs; [
    # cli/dev utils
    carapace
    gnumake
    bat
    less
    du-dust
    procs
    killall
    bottom
    fd
    tokei
    git-quick-stats
    ripgrep
    xclip
    entr
    file
    exiftool
    jq
    zip
    unzip
    nurl
    # general helpful stuff
    et
    pass
    safeeyes
    networkmanagerapplet
    yubioath-flutter
    obsidian
    zotero
    # multimedia
    pdftk
    mupdf
    pulsemixer
    moreutils
    ffmpeg
    sxiv
    vlc
    mpv
    gnome.nautilus
    notify-desktop
    # script/WM dependencies
    maim
    xbindkeys
    xdotool
  ];
  home.file = {
    "awesome" = {
      source = ../awesome;
      target = "./.config/awesome";
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
    "ultisnips" = {
      source = ../nvim/snippets;
      target = ".config/nvim/ultisnips";
    };
  };

  xsession = {
    windowManager.awesome.enable = true;
  };
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    x11.enable = true;
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
