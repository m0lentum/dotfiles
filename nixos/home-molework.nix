{ config, pkgs, ... }:

{
  imports = [ ./home-common.nix ];
  programs = {
    # sign commits at work with work email
    git.userEmail = pkgs.lib.mkForce "mikael.b.myyra@jyu.fi";
    jujutsu.settings.user.email = pkgs.lib.mkForce "mikael.b.myyra@jyu.fi";
  };
  services = {
    picom.backend = pkgs.lib.mkForce "glx";
    safeeyes.enable = pkgs.lib.mkForce false;
  };
  home.packages = with pkgs; [
    teams-for-linux
    zoom-us
    zulip
    spotify
    virt-manager
    vagrant
    docker-compose
    podman-compose
    pyright
    fuse
    bindfs
    camunda-modeler
  ];
}
