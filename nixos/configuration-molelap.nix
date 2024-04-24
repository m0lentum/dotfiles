{ config, pkgs, ... }:

{
  imports = [
    ./hardware-molelap.nix
    ./configuration-common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "molelap";
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.interfaces.wwp0s29u1u6i6.useDHCP = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
  users.extraUsers.mole.openssh.authorizedKeys.keyFiles = [
    "/home/mole/.ssh/moletable.pub"
  ];
  # if ssh, use the forwarded socket (set to different path from
  # default socket to allow both direct use and ssh use with yubikey)
  environment.shellInit = ''
    if [ -n "$SSH_CONNECTION" ]; then
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh.remote"
    else
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    fi
  '';

  services.xserver = {
    videoDrivers = [ "intel" ];
    xkb.layout = "fi-molemak";
    # Enable touchpad support.
    libinput.enable = true;
  };

  environment.variables.AWESOME_GAP = "0";
  environment.variables.AWESOME_BATTERY = "1";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

