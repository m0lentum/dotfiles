{ config, pkgs, ... }:

let
  micromamba = (import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/64065d76f434457073f5d255a3246658119e08ed.tar.gz";
    sha256 = "01nk76zhx5pf5ay0czcyikxqmrpr68gsvil3h4jy6sknrrid962m";
  }) {}).micromamba;
  rcc = pkgs.callPackage ./rcc { micromamba = micromamba; };
  robocode = (pkgs.vscode-fhsWithPackages (ps: with ps; [
    (ps.python3Full.withPackages(ps: [
      (ps.robotframework.overridePythonAttrs(old: rec {
        version = "4.1.1";
        src =  ps.fetchPypi {
          pname = "robotframework";
          extension = "zip";
          inherit version;
          sha256 = "0ddd9dzrn9gi29w0caab78zs6mx06wbf6f99g0xrpymjfz0q8gv6";
        };
        doCheck = false;
      }))
    ]))
  ]));
  robocode-exts = (with pkgs.vscode-extensions; [
    ms-python.python
    ms-vsliveshare.vsliveshare
    vscodevim.vim
    (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
      mktplcRef = {
        name = "robotframework-lsp";
        publisher = "robocorp";
        version = "0.23.2";
        sha256 = "1lcgnrspqh1fkp9kzslfmcmvvvrwjbgvna1qd0dba4qpskaj1ggg";
      };
    })
    (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
      mktplcRef = {
        name = "robocorp-code";
        publisher = "robocorp";
        version = "0.15.0";
        sha256 = "140m8gqwc63b3fdyy44kzwjq7dvj05ivgcralhqgpx1rckp4i2hh";
      };
      postInstall = ''
        mkdir -p $out/share/vscode/extensions/robocorp.robocorp-code/bin
        ln -s ${rcc}/bin/rcc $out/share/vscode/extensions/robocorp.robocorp-code/bin
      '';
    })
  ]);
in
{ imports = [ ./common.nix ];
  services = {
    picom.backend = pkgs.lib.mkForce "glx";
  };
  home.packages = [
    pkgs.teams
    pkgs.spotify
  ];
  # vscode with robocorp extensions
  programs.vscode = {
    enable = true;
    package = robocode;
    extensions = robocode-exts;
  };
}
