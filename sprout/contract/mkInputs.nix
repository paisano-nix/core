{
  super,
  root,
}: let
  inherit (root.api) inputs;
  inherit (super) deSystemize;
in
  system:
    deSystemize system inputs
