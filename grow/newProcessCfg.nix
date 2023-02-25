/*
This file validates and prorpocesses the grow function arguments.
*/
{
  l,
  types,
}: cfg:
# for showing the flake that has the problem
sourceInfo: let
  inherit (types) BlockTypes Systems Cell;
  inherit (cfg) cellBlocks systems cellsFrom;
  originFlake = "${sourceInfo}/flake.nix";
  origin = key: (builtins.unsafeGetAttrPos key cfg).file or originFlake;
in rec {
  cellBlocks' = let
    unique =
      l.foldl' (
        acc: e:
          if l.elem e.name acc.visited
          then acc
          else {
            visited = acc.visited ++ [e.name];
            result = acc.result ++ [e];
          }
      ) {
        visited = [];
        result = [];
      };
  in
    (unique
      (BlockTypes "${origin "cellBlocks"} - grow[On]:cellBlocks" cellBlocks))
    .result;
  systems' = Systems "${origin "systems"} - grow[On]:systems" systems;
  cells' = l.mapAttrsToList (Cell originFlake cellsFrom cellBlocks') (l.readDir cellsFrom);
}
