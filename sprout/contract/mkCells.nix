{root}: let
  inherit (root) forEachSystem;
in
  toplevel:
  # TODO: fix and push down
    forEachSystem (sys: toplevel.${sys})
