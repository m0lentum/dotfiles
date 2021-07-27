{ config, pkgs, ... }:

{
  imports = [
    ./hardware-moletable.nix
    ./common.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.steam.enable = true;

  # run JACK on the external soundcard so it doesn't need to worry about pulseaudio
  services.jack = {
    jackd.enable = true;
    jackd.extraOptions = [
      "-R" "-dalsa" "-dhw:USB" "--period" "256" "--nperiods" "3" "--rate" "48000"
    ];
    alsa.enable = false;
  };

  environment.variables = {
    LV2_PATH = "/home/mole/.nix-profile/lib/lv2";
  };

  # docker for work stuff
  virtualisation.docker.enable = true;

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
    { output = "DP-0"; primary = true; }
    "DP-2"
    "DVI-D-0"
  ];
  # enable vsync and position screens
  services.xserver.screenSection = ''
    Option "metamodes" "DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: nvidia-auto-select +2560+0, DVI-D-0: nvidia-auto-select +5120+0 {Rotation=right, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    Option "DPI" "96 x 96"
  '';
  # the only way I could come up with to get awesome to see my environment variables
  services.xserver.windowManager.awesome.package = pkgs.symlinkJoin {
    name = "awesome";
    paths = [
      (pkgs.writeScriptBin "awesome" ''
        #!${pkgs.stdenv.shell}
        export AWESOME_PADDING_DP_0=40
        export AWESOME_PADDING_DP_2=200
        exec ${pkgs.awesome}/bin/awesome
      '')
      pkgs.awesome
    ];
  };

  # systemd-udev-settle hangs the system for 2 minutes on startup and apparently isn't needed
  systemd.services.systemd-udev-settle.enable = false;

  programs.fuse.userAllowOther = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
