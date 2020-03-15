{ config, pkgs, ... }:

{ imports = [ ./common.nix ];
  home.packages = with pkgs; [
    discord
    spotify
    steam
    wine
    jack2
    reaper
  ];
}