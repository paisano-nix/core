{super}: let
  inherit (super.api) cellsFrom;
in {
  __schema = "v0";
  inherit cellsFrom;
}
