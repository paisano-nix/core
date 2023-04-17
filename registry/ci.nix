{
  lib,
  super,
  apex,
}: let
  inherit (lib) flatten attrValues;
  inherit (super) mapOverPaisanoTree resolveCi;
in
  mapOverPaisanoTree {
    onSystems = _: c: _: flatten (attrValues c);
    onCells = _: c: _: attrValues c;
    onBlocks = _: c: _: attrValues c;
    onTargets = cr: _: resolveCi cr;
  }
  apex
