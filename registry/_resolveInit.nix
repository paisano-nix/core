{
  lib,
  super,
}: let
  inherit (lib) nameValuePair mapAttrsToList mapNullable;
  inherit (super) resolveActions;
  inherit (super.api) cellBlocks;
  inherit
    (super.mapOverPaisanoTree)
    getSystem
    getCell
    getBlock
    getTarget
    ;
in
  cursor: target: let
    actions = resolveActions cursor target;
  in {
    name = getTarget cursor; # TODO: cleanup
    actions =
      mapNullable (mapAttrsToList (name: a: {
        inherit name;
        inherit (a) description;
      }))
      actions;
  }
