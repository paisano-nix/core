{args}: let
  inherit (builtins) listToAttrs;
in {
  inherit (args) cellsFrom;
  cellBlocks = listToAttrs (
    map (b: {
      inherit (b) name;
      value = b // {ci = b.ci or null;};
    })
    args.cellBlocks
  );
}
