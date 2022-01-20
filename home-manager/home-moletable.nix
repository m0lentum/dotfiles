{ config, pkgs, ... }:

let
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
  backup = pkgs.writeScriptBin "backup" ''
    #! /usr/bin/env nix-shell
    #! nix-shell -p borgbackup -i bash

    if [[ -z $BORG_REPO || -z $BORG_PASSPHRASE ]]; then
      echo "Please set BORG_REPO and BORG_PASSPHRASE"
      exit 1
    fi

    # some helpers and error handling:
    echo() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
    trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

    echo "Starting backup"

    borg create                         \
        --verbose                       \
        --filter AME                    \
        --list                          \
        --stats                         \
        --show-rc                       \
        --compression lz4               \
        --exclude-caches                \
                                        \
        ::'{hostname}-{now}'            \
        /data/videos                    \
        /data/pictures                  \
        /data/books                     \
        /data/games/Livesplit_1.4.5     \
        /data/music                     \
        /data/documents                 \
        /data/steam-windows/steamapps/common/Beat\ Saber/UserData \
        /data/steam-windows/steamapps/common/Beat\ Saber/Beat\ Saber_Data/CustomLevels \
        /home/mole/CELSYS               \
        /home/mole/stuff                \
        /home/mole/.config/krita*       \

    backup_exit=$?

    echo "Pruning repository"

    borg prune                          \
        --list                          \
        --prefix '{hostname}-'          \
        --show-rc                       \
        --keep-daily    3               \
        --keep-weekly   2               \
        --keep-monthly  3               \

    prune_exit=$?

    # use highest exit code as global exit code
    global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

    if [ $global_exit -eq 0 ]; then
        echo "Backup and Prune finished successfully"
    elif [ $global_exit -eq 1 ]; then
        echo "Backup and/or Prune finished with warnings"
    else
        echo "Backup and/or Prune finished with errors"
    fi

    exit $global_exit
  '';
  # pad images to A4 aspect ratio for printing
  # (otherwise my printer will stretch them)
  a4pad = pkgs.writeScriptBin "a4pad" ''
    #! /usr/bin/env nix-shell
    #! nix-shell -p busybox file imagemagick -i bash

    A4_ASPECT=1.4142

    src=$1
    if [ -z "$src" ]; then
      echo "source file pls"
      exit 1
    fi
    dest=$2
    if [ -z "$dest" ]; then
      dest=$src
    fi

    dims=$(file "$src" | rg '^.*, ([0-9]+\s?x\s?[0-9]+),.*$' -r '$1')
    w=$(echo $dims | rg '^([0-9]+)\s?x.*$' -r '$1')
    h=$(echo $dims | rg '^[0-9]+\s?x\s?([0-9]+)$' -r '$1')
    if [ $h -gt $w ]; then
      echo "portrait"
      aspect_error=$(echo "($h/$w)-$A4_ASPECT" | bc -l)
      if [ "''${aspect_error:0:1}" != "-" ]; then
        target_h=$h
        target_w=$(echo "$h/$A4_ASPECT" | bc -l | xargs printf "%.0f")
        echo "padding horizontally to ''${target_w}x''${target_h}"
      else
        target_w=$w
        target_h=$(echo "$w*$A4_ASPECT" | bc -l | xargs printf "%.0f")
        echo "padding vertically to ''${target_w}x''${target_h}"
      fi
    else
      echo "landscape"
      aspect_error=$(echo "($w/$h)-$A4_ASPECT" | bc -l)
      if [ "''${aspect_error:0:1}" != "-" ]; then
        target_w=$w
        target_h=$(echo "$w/$A4_ASPECT" | bc -l | xargs printf "%.0f")
        echo "padding vertically to ''${target_w}x''${target_h}"
      else
        target_h=$h
        target_w=$(echo "$h*$A4_ASPECT" | bc -l | xargs printf "%.0f")
        echo "padding horizontally to ''${target_w}x''${target_h}"
      fi
    fi

    dims="''${target_w}x''${target_h}"
    convert "$src" -resize "$dims" -background white -gravity center -extent "$dims" "$dest"
  '';
in
{ imports = [ ./common.nix ];
  nixpkgs.config.allowUnfree = true;
  programs = {
    obs-studio = {
      enable = true;
      # obs-linuxbrowser isn't in nixpkgs on 21.05.
      # I don't need it atm since I stream from windows, so leaving it off
      # plugins = [ pkgs.obs-linuxbrowser ];
    };
  };
  home.packages = [
    cam
    backup
    a4pad

    pkgs.discord
    pkgs.tdesktop # telegram
    pkgs.teams
    pkgs.zoom-us

    pkgs.dolphinEmuMaster
    pkgs.spotify

    pkgs.krita
    pkgs.inkscape

    pkgs.ardour
    pkgs.guitarix
    pkgs.drumgizmo
    pkgs.zynaddsubfx
    pkgs.geonkick
    pkgs.artyFX

    pkgs.lm_sensors
  ];
}
