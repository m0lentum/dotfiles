{ config, pkgs, ... }:

{
  imports = [ ./hardware-moletable.nix ./common.nix ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    version = 2;
    device = "nodev";
    useOSProber = true;
  };

  networking.hostName = "moletable";
  networking.interfaces.enp30s0.useDHCP = true;
  services.xserver.layout = "fi";
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.wacom.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.xserver.xrandrHeads = [
    { output = "DP-2"; primary = true; }
    "DVI-D-0"
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

