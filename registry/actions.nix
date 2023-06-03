{
  lib,
  super,
  apex,
}: let
  inherit (lib) mapAttrs id;
  inherit (super) mapOverPaisanoTree resolveActions;
in
  mapOverPaisanoTree {
    onSystems = _: _: id;
    onCells = _: _: id;
    onBlocks = _: _: id;
    onTargets = cr: target:
      mapAttrs (_: a: a.command)
      (resolveActions cr target);
  }
  apex
