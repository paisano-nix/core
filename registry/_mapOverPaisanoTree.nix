{
  super,
  lib,
}: let
  inherit (lib) length elemAt isFunction isAttrs;
  inherit (super) mapOverTree;

  isSystem = cursor: length cursor == 1;
  getSystem = cursor: elemAt cursor 0;
  isCell = cursor: length cursor == 2;
  getCell = cursor: elemAt cursor 1;
  isBlock = cursor: length cursor == 3;
  getBlock = cursor: elemAt cursor 2;
  isTarget = cursor: length cursor == 4;
  getTarget = cursor: elemAt cursor 3;

  ifNoStumpCell = f: value:
    if ! isAttrs value
    then null
    else f;
in {
  inherit
    getSystem
    getCell
    getBlock
    getTarget
    ifNoStumpCell
    ;

  __functor = _: {
    onSystems,
    onCells,
    onBlocks,
    onTargets,
  }:
  # assert (isFunction onSystem) "onSystem must be a function consuming it's own children";
  # assert (isFunction onCells) "onCells must be a function consuming it's own children";
  # assert (isFunction onBlocks) "onBlocks must be a function consuming it's own children";
  # assert isFuncion onTargets "onTargets must not be a function as it ends recursion";
    mapOverTree (cursor: (
      if isSystem cursor
      then onSystems cursor
      else if isCell cursor
      then onCells cursor
      else if isBlock cursor
      then onBlocks cursor
      else onTargets cursor
    ));
}
