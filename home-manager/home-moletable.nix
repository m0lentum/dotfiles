{ config, pkgs, ... }:

let
  csp = pkgs.writeScriptBin "csp" ''
    #!${pkgs.stdenv.shell}
    wine "/home/mole/.wine/drive_c/Program Files/CELSYS/CLIP STUDIO 1.5/CLIP STUDIO PAINT/CLIPStudioPaint.exe"
  '';
  cam = pkgs.writeScriptBin "cam" ''
    #!${pkgs.stdenv.shell}
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
      plugins = with pkgs; [
        obs-linuxbrowser
        # This does not install correctly,
        # and also doesn't seem to work with the iOS camera app anymore anyway
        # obs-ndi
      ];
    };
  };
  home.packages = with pkgs; [
    csp
    cam
    ffmpeg
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
