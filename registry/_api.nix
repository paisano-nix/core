{
  args,
  super,
}: let
  inherit (builtins) listToAttrs;
  inherit (super) types;
  inherit (builtins) foldl' elem;

  originFlake = "${args.inputs.self.sourceInfo}/flake.nix";
  origin = key: (builtins.unsafeGetAttrPos key args).file or originFlake;
in {
  inherit (args) cellsFrom;
  cellBlocks = listToAttrs (
    map (b: {
      inherit (b) name;
      value = b // {ci = b.ci or null;};
    })
    (types.BlockTypes "${origin "cellBlocks"} - grow[On]:cellBlocks" args.cellBlocks)
  );
}
