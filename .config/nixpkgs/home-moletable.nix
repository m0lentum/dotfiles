{ config, pkgs, ... }:

{ imports = [ ./common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    direnv.enable = true;
  };
  services = {
    lorri.enable = true;
  };
  home.packages = with pkgs; [
    discord
    spotify
    steam
    wine
    jack2
    reaper
    google-chrome
  ];
}