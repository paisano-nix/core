{
  api,
  lib,
}: let
  inherit (lib) concatStringsSep drop;
  inherit (api) cellsFrom;

  dropSys = drop 1;

  mkPath = cr: suffix: "${cellsFrom}/" + (concatStringsSep "/" (dropSys cr)) + suffix;
in
  cursor:
    mkPath cursor [
      ".md"
      "/readme.md"
      "/Readme.md"
      "/README.md"
    ]
