/*
This file implements an extractor that feeds the registry.
*/
{
  l,
  paths,
  types,
}: cellsFrom: system: cellName: cellBlock: targetTracer: name: target: let
  tPath = paths.targetPath cellsFrom cellName cellBlock name;
  fragment = ''"${system}"."${cellName}"."${cellBlock.name}"."${name}"'';
  actions' =
    if cellBlock ? actions
    then
      l.listToAttrs (
        map
        (a: l.nameValuePair a.name a) (cellBlock.actions {
          inherit target fragment;
          fragmentRelPath = "${cellName}/${cellBlock.name}/${name}";
          # in impure mode, detect the current system to run
          # the action's executables themselves with correct arch
          currentSystem = builtins.currentSystem or system;
        })
      )
    else {};
  ci =
    if cellBlock ? ci
    then
      l.mapAttrsToList (action: _:
        if ! l.hasAttr action actions'
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
      action = types.ActionCommand "Action \"${action'.name}\" of Cell Block \"${cellBlock.name}\" (Cell Block Type: \"${cellBlock.type}\")" action'.command;
    in
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
    targetTracer name
    {
      inherit name;
      # for speed only extract name & description, the bare minimum for display
      actions =
        l.mapAttrsToList (name: a: {
          inherit name;
          inherit (a) description;
        })
        actions';
    }
    // (l.optionalAttrs (l.pathExists tPath.readme) {inherit (tPath) readme;})
    // (l.optionalAttrs (target ? meta && target.meta ? description) {inherit (target.meta) description;});
}
