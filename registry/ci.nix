{
  lib,
  super,
  apex,
}: let
  inherit (lib) flatten attrValues filter;
  inherit (super) mapOverPaisanoTree resolveCi;
  inherit (super.mapOverPaisanoTree) ifNoStumpCell;
in
  mapOverPaisanoTree {
    onSystems = _: _: c: filter (v: v != null) (flatten (attrValues c));
    onCells = _: _: c: filter (v: v != null) (flatten (attrValues c));
    onBlocks = _: ifNoStumpCell attrValues;
    onTargets = cr: resolveCi cr;
  }
  apex
