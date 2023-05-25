{ config, pkgs, pkgsUnstable, ... }:

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

  shells = import ./home-modules/shells.nix { inherit pkgs pkgsUnstable listIgnores; };

  # helper script because I always forget the exact way to nix-prefetch-url from github
  prefetchGithub = pkgs.writeScriptBin "nix-prefetch-github" ''
    #! /usr/bin/env bash
    if [ "$#" -ne 3 ]; then
      echo "usage: nix-prefetch-github <owner> <repo> <rev>"
      exit 1
    fi
    nix-prefetch-url --unpack "https://github.com/$1/$2/archive/$3.tar.gz"
  '';
in
{
  nixpkgs.config.allowUnfree = true;
  programs = {
    git = import ./home-modules/git.nix { inherit pkgs; };
    fish = shells.fish;
    nushell = shells.nushell;
    starship = import ./home-modules/starship.nix { inherit pkgs pkgsUnstable; };
    kitty = import ./home-modules/kitty.nix { inherit pkgs; };
    tmux = import ./home-modules/tmux.nix { };
    nnn = import ./home-modules/nnn.nix { inherit pkgs; };
    neovim = import ./home-modules/neovim.nix { inherit pkgs listIgnores; };
    firefox = {
      enable = true;
      package = (pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.passff-host ]; });
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
    jq
    zip
    unzip
    prefetchGithub
    # general helpful stuff
    et
    pass
    safeeyes
    networkmanagerapplet
    # this is not on stable yet and the old yubioath-desktop doesn't work anymore
    pkgsUnstable.yubioath-flutter
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
    pcmanfm
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
