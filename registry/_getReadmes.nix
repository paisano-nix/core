{
  lib,
  super,
}: let
  inherit (lib) concatStringsSep drop;
  inherit (super.api) cellsFrom;

  dropSys = drop 1;

  mkPath = cr: suffix: "${cellsFrom}/" + (concatStringsSep "/" (dropSys cr)) + suffix;
in
  cursor:
    map (mkPath cursor) [
      ".md"
      "/readme.md"
      "/Readme.md"
      "/README.md"
    ]
