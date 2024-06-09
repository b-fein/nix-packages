{
  pkgs ? import <nixpkgs> {},
  system ? pkgs.stdenv.system,
}:
with pkgs; rec {
  verapdf = callPackage ./verapdf/default.nix {};
}
