{
  lib,
  super,
}: let
  inherit (lib) mapAttrsToList mapNullable;
  inherit (super) resolveActions;
  inherit
    (super.mapOverPaisanoTree)
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
