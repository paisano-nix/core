{
  yants,
  lib,
}: {
  Systems = log: with yants log; list (enum "System" lib.systems.doubles.all);
  Scope = log:
    with yants log;
      scope: (
        if lib.typeOf scope == "set"
        then attrs any scope
        else
          functionWithArgs {
            inputs = false;
            scope = false;
          }
          scope
      );
}
