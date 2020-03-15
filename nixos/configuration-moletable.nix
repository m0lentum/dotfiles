{ config, pkgs, ... }:

{
  imports = [ ./hardware-moletable.nix ./common.nix ];

  networking.hostName = "moletable";
  services.xserver.layout = "fi";
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

