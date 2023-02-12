{
  l,
  yants,
  paths,
}: {
  Cell = import ./cell.nix {
    inherit l;
    inherit (paths) cellPath cellBlockPath;
  };
  Target = log: type:
    with yants log; let
      type' =
        # TODO: remove in the future and make a specific type a hard requirement
        if type == null
        then any
        else type;
    in
      attrs type';
  Systems = log: with yants log; list (enum "system" l.systems.doubles.all);
  BlockTypes = log:
    with yants log;
      list (struct "cellBlock" {
        name = string;
        type = string;
        __type = option type;
        __functor = option function;
        ci = option (attrs bool);
        cli = option bool;
        actions = option (functionWithArgs {
          system = false;
          target = false;
          fragment = false;
          fragmentRelPath = false;
        });
      });
  Block = log:
    with yants log;
      block: (
        if l.typeOf block == "set"
        then attrs any block
        else
          functionWithArgs {
            inputs = false;
            cell = false;
          }
          block
      );
  ActionCommand = with yants "std" "actions"; drv;
}
