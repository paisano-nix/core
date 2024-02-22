/*
This file implements an extractor that feeds the registry.
*/
{
  l,
  paths,
  types,
}: cellsFrom: system: cellName: cellBlock: targetTracer: inputs: name: target: let
  tPath = paths.targetPath cellsFrom cellName cellBlock name;
  fragment = ''"${system}"."${cellName}"."${cellBlock.name}"."${name}"'';
  actions' =
    if cellBlock ? actions
    then
      l.listToAttrs (
        map
        (a: l.nameValuePair a.name a) (cellBlock.actions {
          inherit target fragment inputs;
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
      l.mapAttrsToList (
        action: _: let
          action' = actions'.${action};
          command = types.ActionCommand "Action \"${action'.name}\" of Cell Block \"${cellBlock.name}\" (Cell Block Type: \"${cellBlock.type}\")" action'.command;
        in (
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
            targetDrv = command.targetDrv or target.drvPath or null; # can be null: nomad mainfests only hold data
            actionDrv = command.drvPath;
            proviso = action'.proviso or null;
            meta = action'.meta or null;
          }
        )
      )
      cellBlock.ci
    else [];
in {
  inherit ci;
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
          requiresArgs =
            if (target ? meta && target.meta ? requiresArgs)
            then (builtins.elem name target.meta.requiresArgs)
            else false;
        })
        actions';
    }
    // l.optionalAttrs (l.pathExists tPath.readme) {inherit (tPath) readme;}
    // l.optionalAttrs (target ? meta && target.meta ? description) {inherit (target.meta) description;};
}
