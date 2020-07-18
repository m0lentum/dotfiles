{ config, pkgs, ... }:

{
  imports = [ ./hardware-molelap.nix ./common.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "molelap";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.interfaces.wwp0s29u1u6i6.useDHCP = true;

  services.xserver = {
    videoDrivers = ["intel"];
    extraLayouts.fi-molemak = {
      description = "Finnish colemak with some modifier customization";
      languages = ["fi"];
      symbolsFile = ../molemak.xkb;
    };
    layout = "fi-molemak";
    # Enable touchpad support.
    libinput.enable = true;
  };

  environment.variables.AWESOME_GAP = "0";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

