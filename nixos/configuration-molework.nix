{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-molework.nix
      ./common.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/b53b4481-40ca-4600-865f-52ccbe52493d";
    preLVM = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "YOPL2109-14";
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  
  services.xserver = {
    # videoDrivers = ["intel"];
    extraLayouts.fi-molemak = {
      description = "Finnish colemak with some modifier customization";
      languages = ["fi"];
      symbolsFile = ../molemak.xkb;
    };
    # fi by default because I'll be using an ergodox with this one most of the time
    layout = "fi";
    # Enable touchpad support.
    libinput.enable = true;
  };

  environment.variables.AWESOME_BATTERY = "1";

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
  users.extraUsers.mole.openssh.authorizedKeys.keyFiles = [
    "/home/mole/.ssh/moleyubi.pub"
  ];

  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

