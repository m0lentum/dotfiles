{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-moletable.nix
    ./common.nix
    <musnix>
  ];

  nixpkgs.config.allowUnfree = true;

  musnix.enable = true;
  musnix.kernel.optimize = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    version = 2;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 10;
  };

  networking.hostName = "moletable";
  networking.interfaces.enp30s0.useDHCP = true;
  # common development server ports
  networking.firewall.allowedTCPPorts = [ 8080 8000 9000 ];

  services.xserver.layout = "fi";
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.wacom.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

  services.xserver.xrandrHeads = [
    { output = "DP-2"; primary = true; }
    "DVI-D-0"
  ];
  # enable vsync
  services.xserver.screenSection = ''   
    Option "metamodes" "DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DVI-D-0: nvidia-auto-select +2560+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
  '';
  # required by Steam
  hardware.opengl.driSupport32Bit = true;

  # systemd-udev-settle hangs the system for 2 minutes on startup and apparently isn't needed
  systemd.services.systemd-udev-settle.enable = false;

  # reject the Oculus Rift and its sensors so we don't run out of USB power
  # (can't use that thing on Linux anyway)
  services.usbguard = {
    enable = true;
    implictPolicyTarget = "allow";
    rules = ''
      reject id one-of { 2833:3031 2833:0211 2833:2031 2833:0211 2833:0031 }
    '';
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

