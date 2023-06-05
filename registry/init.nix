{
  lib,
  super,
  apex,
}: let
  inherit (lib) optionalAttrs pathExists findFirst attrValues filter;
  inherit (super) mapOverPaisanoTree resolveInit getReadmes;
  inherit (super.api) cellBlocks;
  inherit
    (super.mapOverPaisanoTree)
    getSystem
    getCell
    getBlock
    getTarget
    ifNoStumpCell
    ;
in
  mapOverPaisanoTree {
    onSystems = _: _: c: filter (v: v.cellBlocks != []) (attrValues c);
    onCells = cr: _: c: let
      readme = findFirst pathExists null (getReadmes cr);
    in
      {
        cell = getCell cr;
        cellBlocks = filter (v: v != null) (attrValues c);
      }
      // (optionalAttrs (readme != null) {inherit readme;});
    onBlocks = cr:
      ifNoStumpCell (c: let
        inherit (cellBlocks.${getBlock cr} or {type = "unknown";}) type;
        readme = findFirst pathExists null (getReadmes cr);
      in
        {
          blockType = type;
          cellBlock = getBlock cr;
          targets = attrValues c;
        }
        // (optionalAttrs (readme != null) {inherit readme;}));
    onTargets = cr: target: let
      init = resolveInit cr target;
      readme = findFirst pathExists null (getReadmes cr);
      targetTracer = name: lib.traceVerbose "Loading ${getSystem cr} {importPaths.importPath}:${name}";
    in
      targetTracer init.name (init
        // optionalAttrs (readme != null) {inherit readme;}
        // optionalAttrs (target ? meta && target.meta ? description) {inherit (target.meta) description;});
  }
  apex
