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
    # fi instead of fi-molemak by default
    # because I'll be using an ergodox with this one most of the time
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
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    libvirtd.enable = true;
  };
  # needed for mounting node_modules
  programs.fuse.userAllowOther = true;

  # stateVersion updated to allow enabling libvirtd and podman simultaneously
  system.stateVersion = "23.11";

}

