{ config, pkgs, ... }:

{
  imports = [
    ./hardware-moletable.nix
    ./configuration-common.nix
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # run JACK on the external soundcard so it doesn't need to worry about pulseaudio
  services.jack = {
    jackd.enable = true;
    jackd.extraOptions = [
      "-R"
      "-dalsa"
      "-dhw:USB"
      "--period"
      "256"
      "--nperiods"
      "3"
      "--rate"
      "48000"
    ];
    alsa.enable = false;
  };

  environment.variables = {
    LV2_PATH = "/home/mole/.nix-profile/lib/lv2";
    AWESOME_PADDING_DP_0 = "40";
    AWESOME_PADDING_DP_2 = "200";
    AWESOME_RYZEN_TEMP = "1";
    BORG_REPO = "/backup/borg";
    BORG_PASSCOMMAND = "pass show home/borg";
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 10;
  };

  networking.hostName = "moletable";
  networking.networkmanager.enable = true;
  # common development server ports
  networking.firewall.allowedTCPPorts = [ 8080 8000 9000 ];

  services.xserver = {
    xkb.layout = "fi";
    videoDrivers = [ "nvidia" ];
    wacom.enable = true;

    xrandrHeads = [
      { output = "DP-0"; primary = true; }
      "DP-2"
      "DVI-D-0"
    ];
    # enable vsync and position screens
    screenSection = pkgs.lib.strings.concatStrings [
      "Option \"metamodes\" "
      "\"DP-0: nvidia-auto-select +1080+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, "
      "DP-2: nvidia-auto-select +3640+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, "
      "HDMI-0: nvidia-auto-select +0+0 {Rotation=left, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}\""
      "Option \"DPI\" \"96 x 96\""
    ];
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

  # systemd-udev-settle hangs the system for 2 minutes on startup and apparently isn't needed
  systemd.services.systemd-udev-settle.enable = false;

  programs.fuse.userAllowOther = true;

  # shenanigans for agent forwarding to work computer
  programs.ssh.extraConfig = ''
    Host work
      User mole
      HostName 192.168.0.170
      ForwardX11 yes
      ForwardX11Trusted yes
      StreamLocalBindUnlink yes
      RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent
      RemoteForward /run/user/1000/gnupg/S.gpg-agent.ssh.remote /run/user/1000/gnupg/S.gpg-agent.ssh
      LocalForward 8000 localhost:8000
      LocalForward 8080 localhost:8080
      LocalForward 8090 localhost:8090
      LocalForward 9695 localhost:9695
      LocalForward 9693 localhost:9693
      LocalForward 3000 localhost:3000

    Host pi
      User pi
      HostName 192.168.0.198
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
