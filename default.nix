{
  pkgs,
  system ? pkgs.stdenv.system,
}:
with pkgs; rec {
  litterbox = callPackage ./litterbox/default.nix {};
}
