{ config, pkgs, ... }:

let
  csp = pkgs.writeScriptBin "csp" ''
    #!${pkgs.stdenv.shell}
    wine "/home/mole/.wine/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5/CLIP STUDIO PAINT/CLIPStudioPaint.exe"
  '';
  cam = pkgs.writeScriptBin "cam" ''
    #! /usr/bin/env nix-shell
    #! nix-shell -p ffmpeg -i bash
    if [[ -z $1 ]]; then
      echo "Usage: cam [IPCamera address]"
      false
    else
      ffmpeg -f mjpeg -i "http://$1/live" -pix_fmt yuv420p -f v4l2 /dev/video0
    fi
  '';
in
{ imports = [ ./common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-linuxbrowser ];
    };
  };
  home.packages = [
    csp
    cam

    pkgs.discord
    pkgs.tdesktop # telegram
    pkgs.spotify

    pkgs.steam
    pkgs.wineWowPackages.stable
    pkgs.dolphinEmuMaster

    pkgs.carla
    pkgs.guitarix
    # installed from unstable with nix-env atm
    # pkgs.reaper
  ];
}
