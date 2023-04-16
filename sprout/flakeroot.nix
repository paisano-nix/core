{
  lib,
  root,
}: let
  inherit (root.api) systems;
in
  f:
    lib.foldl (
      toplevel: system:
        toplevel
        // {
          ${system} = f system;
        }
    ) {}
    systems
