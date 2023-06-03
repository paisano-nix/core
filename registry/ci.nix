{
  lib,
  super,
  apex,
}: let
  inherit (lib) flatten attrValues filter;
  inherit (super) mapOverPaisanoTree resolveCi;
in
  mapOverPaisanoTree {
    onSystems = _: _: c: filter (v: v != null) (flatten (attrValues c));
    onCells = _: _: c: attrValues c;
    onBlocks = _: _: c: attrValues c;
    onTargets = cr: resolveCi cr;
  }
  apex
