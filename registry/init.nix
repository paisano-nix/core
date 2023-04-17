{
  lib,
  super,
  apex,
}: let
  inherit (lib) optionalAttrs pathExists findFirst;
  inherit (super) mapOverPaisanoTree resolveInit getReadmes;
  inherit (super.api) cellBlocks;
  inherit
    (super.mapOverPaisanoTree)
    getSystem
    getCell
    getBlock
    getTarget
    ;
in
  mapOverPaisanoTree {
    onSystems = _: c: _: attrValues c;
    onCells = cr: c: _: {
      cell = getCell cr;
      cellBlocks = c;
      readme = findFirst pathExists null (getReadmes cr);
    };
    onBlocks = cr: c: _: let
      inherit (cellBlocks.${getBlock cr}) type;
    in {
      blockType = type;
      cellBlock = getBlock cr;
      targets = c;
      readme = findFirst pathExists null (getReadmes cr);
    };
    onTargets = cr: _: target: let
      init = resolveInit cr;
      readme = getReadmes cr;
    in
      init
      // {
        readme = findFirst pathExists null (getReadmes cr);
      }
      // (optionalAttrs (target ? meta && target.meta ? description) {inherit (target.meta) description;});
  }
  apex
