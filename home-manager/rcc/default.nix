{ buildFHSUserEnv, buildGoPackage, go-bindata, rake, zip, micromamba }:

let rcc = buildGoPackage rec {
  name = "rcc-${version}";
  version = "v9.16.0";
  goPackagePath = "github.com/robocorp/rcc";
  src = (import ./sources.nix).rcc;
  nativeBuildInputs = [ go-bindata rake zip ];
  goDeps = ./rcc.nix;
  postPatch = ''
    source $stdenv/setup
    substituteInPlace Rakefile --replace "\$HOME/go/bin/" ""
    rake assets
  '';
};

in buildFHSUserEnv {
  name = "rcc";
  targetPkgs = pkgs: (with pkgs; [
    rcc
    micromamba
  ]);
  runScript = "rcc";
}
