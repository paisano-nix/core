/*
This file implements an extractor that feeds the registry.
*/
{
  l,
  paths,
  types,
}: cellsFrom: system: cellName: cellBlock: name: target: let
  tPath = paths.targetPath cellsFrom cellName cellBlock name;
  actions' =
    if cellBlock ? actions
    then
      l.listToAttrs (
        map
          (a: l.nameValuePair a.name a) (cellBlock.actions {
            inherit system target;
            fragment = ''"${system}"."${cellName}"."${cellBlock.name}"."${name}"'';
            fragmentRelPath = "${cellName}/${cellBlock.name}/${name}";
          })
      )
    else {};
  ci =
    if cellBlock ? ci
    then
      l.mapAttrsToList (action: _:
        if ! l.hasAttrs action actions'
        then
          throw ''
            divnix/std(ci-integration): Block Type '${cellBlock.type}' has no '${action}' Action defined.
            ---
            ${l.generators.toPretty {} (l.removeAttrs cellBlock ["__functor"])}
          ''
        else {
          inherit name;
          cell = cellName;
          block = cellBlock.name;
          blockType = cellBlock.type;
          inherit action;
        })
      cellBlock.ci
    else [];

  ci' = let
    f = set: let
      action' = actions'.${set.action};
      action = action.command;
    in
      assert l.assertMsg (l.isDerivation action) ''
        action must be a derivation. Please file a bug in divnix/paisano if you hit this line.
      '';
      set
      // {
        targetDrv = action.targetDrv or target.drvPath or null; # can be null: nomad mainfests only hold data
        actionDrv = action.drvPath;
      }
      // (
        l.optionalAttrs (action' ? proviso) {inherit (action') proviso;}
      );
  in
    map f ci;
in {
  inherit ci ci';
  actions = l.mapAttrs (_: a: a.command) actions';
  init =
    {
      inherit name;
      # for speed only extract name & description, the bare minimum for display
      actions = l.mapAttrsToList (name: a: {inherit name; inherit (a) description;}) actions';
    }
    // (l.optionalAttrs (l.pathExists tPath.readme) {inherit (tPath) readme;})
    // (l.optionalAttrs (target ? meta && target.meta ? description) {inherit (target.meta) description;});
}
