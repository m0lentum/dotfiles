{ config, pkgs, ... }:

# Everything that is identical between my laptop and desktop is here.
{
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fi";
  };
  time.timeZone = "Europe/Helsinki";

  environment.systemPackages = with pkgs; [
    # git and firefox so we can easily install home-manager; it will handle the rest
    git firefox
  ];
  programs.vim.defaultEditor = true;
  programs.fish.enable = true;
  programs.gnupg.agent.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
    displayManager.defaultSession = "none+awesome";
    desktopManager.xterm.enable = false;
    # disable automatic screen blanking and stuff, we'll do it manually instead
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mole = {
    isNormalUser = true;
    home = "/home/mole";
    description = "mole";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "realtime" "audio" "jackaudio" "docker" ];
  };
}
