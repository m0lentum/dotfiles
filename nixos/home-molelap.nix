{ config, pkgs, ... }:

{
  imports = [ ./home-common.nix ];
  # picom causes too much latency on this slow computer, turn it off
  services.picom.enable = pkgs.lib.mkForce false;
}
