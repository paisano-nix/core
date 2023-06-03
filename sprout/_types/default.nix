{
  yants,
  lib,
}: {
  Systems = log: with yants log; list (enum "System" lib.systems.doubles.all);
  Block = log:
    with yants log;
      block: (
        if lib.typeOf block == "set"
        then attrs any block
        else
          functionWithArgs {
            inputs = false;
            cell = false;
          }
          block
      );
}
