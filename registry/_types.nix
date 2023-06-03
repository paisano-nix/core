{
  lib,
  yants,
}: {
  ActionCommand = log: with yants log; drv;
  BlockTypes = log:
    with yants log;
      list (struct "Cell Block" {
        name = string;
        type = string;
        __functor = option function;
        ci = option (attrs bool);
        cli = option bool;
        actions = option (functionWithArgs {
          target = false;
          fragment = false;
          fragmentRelPath = false;
          currentSystem = false;
        });
      });
}
