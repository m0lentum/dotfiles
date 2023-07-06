{ config, pkgs, ... }:

{
  imports = [
    ./hardware-molework.nix
    ./configuration-common.nix
  ];

  boot.loader.grub = {
    enable = true;
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
      languages = [ "fi" ];
      symbolsFile = ../molemak.xkb;
    };
    # fi by default because I'll be using an ergodox with this one most of the time
    layout = "fi";
    # Enable touchpad support.
    libinput.enable = true;
    xrandrHeads = [
      "eDP-1"
      { output = "DP-1"; primary = true; }
    ];
  };

  environment.variables.AWESOME_BATTERY = "1";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
  users.extraUsers.mole.openssh.authorizedKeys.keyFiles = [
    "/home/mole/.ssh/moleyubi.pub"
  ];
  nix.settings.trusted-users = [ "root" "mole" ];
  # if ssh, use the forwarded socket (set to different path from
  # default socket to allow both direct use and ssh use with yubikey)
  environment.shellInit = ''
    if [ -n "$SSH_CONNECTION" ]; then
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh.remote"
    else
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    fi
  '';
  # sudo via ssh
  security.pam.enableSSHAgentAuth = true;
  # don't allow logging in with just password
  security.pam.yubico.control = "required";

  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };
  # don't suspend on lid close so we can use ssh or second monitor while closed
  services.logind.lidSwitch = "lock";

  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    libvirtd.enable = true;
  };
  # needed for mounting node_modules
  programs.fuse.userAllowOther = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

