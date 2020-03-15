{ config, pkgs, ... }:

{
  imports = [ ./hardware-molelap.nix ./configuration-molelap.nix ];

  networking.hostName = "molelap";
  services.xserver.layout = "fi-molemak";
  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

