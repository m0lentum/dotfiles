{ config, pkgs, ... }:

{ imports = [ ./common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-linuxbrowser pkgs.obs-ndi ];
    };
  };
  home.packages = with pkgs; [
    discord
    spotify
    steam
    wineWowPackages.stable
    cadence
    carla
    guitarix
    reaper
  ];
}