{ config, pkgs, ... }:

{ imports = [ ./common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    direnv.enable = true;
    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-linuxbrowser pkgs.obs-ndi ];
    };
  };
  services = {
    lorri.enable = true;
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