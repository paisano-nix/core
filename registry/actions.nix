{
  lib,
  super,
  apex,
}: let
  inherit (lib) mapAttrs;
  inherit (super) mapOverPaisanoTree resolveActions;
in
  mapOverPaisanoTree {
    onSystems = _: c: _: c;
    onCells = _: c: _: c;
    onBlocks = _: c: _: c;
    onTargets = cr: _: target:
      mapAttrs (_: a: a.command)
      (resolveActions cr target);
  }
  apex
