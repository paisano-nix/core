{
  lib,
  super,
}: let
  inherit (lib) nameValuePair mapAttrsToList mapNullable generators removeAttrs;
  inherit (super) resolveActions types;
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
    inherit
      (cellBlocks.${getBlock cursor}
        or {
          type = "unknown";
          ci = null;
        })
      ci
      type
      ;
    actions = resolveActions cursor target;
  in
    mapNullable (
      mapAttrsToList (
        name: _: let
          action = actions.${name};
          command = types.ActionCommand "Action \"${name}\" of Cell Block \"${getBlock cursor}\" (Cell Block Type: \"${type}\")" action.command;
        in
          if actions ? ${name}
          then {
            cell = getCell cursor;
            block = getBlock cursor;
            blockType = type;
            name = getTarget cursor; # TODO: cleanup
            action = name; # TODO: cleanup
            targetDrv = command.targetDrv or target.drvPath or null; # can be null for e.g. data
            actionDrv = command.drvPath;
            proviso = action.proviso or null;
            meta = action.meta or null;
          }
          else
            throw ''
              paisano: Block Type '${type}' has no '${name}' Action defined.
              ---
              ${generators.toPretty {} (removeAttrs cellBlocks.${getBlock cursor} ["__functor"])}
            ''
      )
    )
    ci
