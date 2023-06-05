{
  lib,
  super,
  apex,
}: let
  inherit (lib) mapAttrs id;
  inherit (super) mapOverPaisanoTree resolveActions;
  inherit (super.mapOverPaisanoTree) ifNoStumpCell;
in
  mapOverPaisanoTree {
    onSystems = _: _: id;
    onCells = _: _: id;
    onBlocks = _: ifNoStumpCell id;
    onTargets = cr: target:
      mapAttrs (_: a: a.command)
      (resolveActions cr target);
  }
  apex
