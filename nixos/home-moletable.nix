{ config, pkgs, ... }:

let
  # convert a network camera into a webcam
  cam = pkgs.writeScriptBin "cam" (builtins.readFile ../scripts/cam.sh);
  # back up files on this computer
  backup = pkgs.writeScriptBin "backup" (builtins.readFile ../scripts/backup-moletable.sh);
  # pad images to A4 aspect ratio for printing
  # (otherwise my printer will stretch them)
  a4pad = pkgs.writeScriptBin "a4pad" (builtins.readFile ../scripts/a4pad.sh);
in
{
  imports = [ ./home-common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    obs-studio.enable = true;
  };
  home.packages = [
    cam
    backup
    a4pad
  ] ++ (with pkgs; [
    (discord.override { nss = pkgs.nss_latest; })
    zoom-us
    zulip
    teams-for-linux

    peek

    spotify

    krita
    inkscape
    blender

    ardour
    guitarix
    drumgizmo
    zynaddsubfx
    geonkick
    artyFX

    lm_sensors
    borgbackup
  ]);
}
