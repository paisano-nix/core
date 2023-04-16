{
  super,
  inputs,
}: let
  inherit (super) deSystemize;
in
  system:
    deSystemize system inputs
