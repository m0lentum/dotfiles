{ buildFHSUserEnv, buildGoPackage, go-bindata, rake, zip, micromamba }:

let rcc = buildGoPackage rec {
  name = "rcc-${version}";
  version = "v11.4.3";
  goPackagePath = "github.com/robocorp/rcc";
  src = (import ./nix/sources.nix).rcc;
  nativeBuildInputs = [ go-bindata rake zip ];
  goDeps = ./deps.nix;
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
