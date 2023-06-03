{
  lib,
  super,
}: let
  inherit (lib) nameValuePair mapNullable concatStringsSep listToAttrs;
  inherit (super.api) cellBlocks;
  inherit
    (super.mapOverPaisanoTree)
    getSystem
    getBlock
    ;

  getFragment = cr: ''"${concatStringsSep ''"."'' cr}"'';
  getFragmentRelPath = cr: ''${concatStringsSep "/" cr}'';
in
  cursor: target: let
    actions = (cellBlocks.${getBlock cursor}).actions or (_: null);
    system = getSystem cursor;
    fragment = getFragment cursor;
    fragmentRelPath = getFragmentRelPath cursor;
  in
    listToAttrs
    (
      map (mapNullable (a: nameValuePair a.name a))
      (actions {
        inherit target fragment fragmentRelPath;
        # in impure mode, detect the current system to run the
        # action itself - not the target - on the correct arch
        currentSystem = builtins.currentSystem or system;
      })
    )
