{ config, pkgs, ... }:

let
  micromamba = (import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/64065d76f434457073f5d255a3246658119e08ed.tar.gz";
      sha256 = "01nk76zhx5pf5ay0czcyikxqmrpr68gsvil3h4jy6sknrrid962m";
    })
    { }).micromamba;
  rcc = pkgs.callPackage ./rcc { micromamba = micromamba; };
  robocode = (pkgs.vscode-fhsWithPackages (ps: with ps; [
    (ps.python3Full.withPackages (ps: [
      (ps.robotframework.overridePythonAttrs (old: rec {
        version = "4.1.1";
        src = ps.fetchPypi {
          pname = "robotframework";
          extension = "zip";
          inherit version;
          sha256 = "0ddd9dzrn9gi29w0caab78zs6mx06wbf6f99g0xrpymjfz0q8gv6";
        };
        doCheck = false;
      }))
    ]))
    rcc
  ]));
  robocode-exts = (with pkgs.vscode-extensions; [
    ms-python.python
    vscodevim.vim
    (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
      mktplcRef = {
        name = "robotframework-lsp";
        publisher = "robocorp";
        version = "0.29.0";
        sha256 = "1waz2kkzy10rjwxpw9wdicm0bz5a10jpy06cwd9f95id1ppn3l0z";
      };
    })
    (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
      mktplcRef = {
        name = "robocorp-code";
        publisher = "robocorp";
        version = "0.20.0";
        sha256 = "09dl08fb0qrnnna4x5d6z3jmj0kkl6gzkjwj12bi7v7khwm0r92a";
      };
      postInstall = ''
        mkdir -p $out/share/vscode/extensions/robocorp.robocorp-code/bin
        ln -s ${rcc}/bin/rcc $out/share/vscode/extensions/robocorp.robocorp-code/bin
      '';
    })
  ]);
in
{
  imports = [ ./home-common.nix ];
  services = {
    picom.backend = pkgs.lib.mkForce "glx";
  };
  home.packages = with pkgs; [
    teams
    zulip
    spotify
    virt-manager
    vagrant
    docker-compose
    pyright
    fuse
    bindfs
  ];
  # vscode with robocorp extensions
  programs.vscode = {
    enable = true;
    package = robocode;
    extensions = robocode-exts;
  };
}
