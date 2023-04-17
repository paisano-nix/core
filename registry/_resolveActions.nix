{
  lib,
  super,
}: let
  inherit (lib) nameValuePair mapAttrsToList mapNullable generators removeAttrs;
  inherit (super.api) cellBlocks;
  inherit
    (super.mapOverPaisanoTree)
    getSystem
    getCell
    getBlock
    getTarget
    ;

  getFragment = cr: ''"${concatStringsSep ''"."'' cr}"'';
  getFragmentRelPath = cr: ''${concatStringsSep "/" cr}'';
in
  cursor: target: let
    actions = (cellBlocks.${getBlock cursor}).actions or null;
    system = getSystem cursor;
    fragment = getFragment cursor;
    fragmentRelPath = getFragmentRelPath cursor;
  in
    mapNullable (
      listToAttrs (map (a: nameValuePair a.name a) (actions {
        inherit target fragent fragmentRelPath;
        # in impure mode, detect the current system to run the
        # action itself - not the target - on the correct arch
        currentSystem = builtins.currentSystem or system;
      }))
    )
    actions
