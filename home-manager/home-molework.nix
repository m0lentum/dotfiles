{ config, pkgs, ... }:

{ imports = [ ./common.nix ];
  services = {
    picom.backend = pkgs.lib.mkForce "glx";
  };
  home.packages = [
    pkgs.teams
    pkgs.spotify
  ];
}
