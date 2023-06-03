{super}: let
  inherit (super.api) cellsFrom;
in {
  __schema = "v0";
  cellsFrom = baseNameOf cellsFrom;
}
