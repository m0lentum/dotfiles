{ config, pkgs, ... }:

{ imports = [ ./common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-linuxbrowser
        # This does not install correctly,
        # and also doesn't seem to work with the iOS camera app anymore anyway
        # obs-ndi
      ];
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