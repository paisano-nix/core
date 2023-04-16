{
  root,
  inputs,
}: let
  inherit (root) deSystemize;
in
  system:
    deSystemize system inputs
