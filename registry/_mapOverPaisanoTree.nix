{
  super,
  lib,
}: let
  inherit (lib) length elemAt;
  inherit (super) mapOverTree;

  isSystem = cursor: length cursor == 1;
  getSystem = cursor: elemAt cursor 0;
  isCell = cursor: length cursor == 2;
  getCell = cursor: elemAt cursor 1;
  isBlock = cursor: length cursor == 3;
  getBlock = cursor: elemAt cursor 2;
  isTarget = cursor: length cursor == 4;
  getTarget = cursor: elemAt cursor 3;
in {
  inherit
    getSystem
    getCell
    getBlock
    getTarget
    ;

  __functor = _: {
    onSystem,
    onCells,
    onBlocks,
    onTargets,
  }:
    assert isFuncion onSystem "onSystem must be a function consuming it's own children";
    assert isFuncion onCells "onCells must be a function consuming it's own children";
    assert isFuncion onBlocks "onBlocks must be a function consuming it's own children";
    # assert isFuncion onTargets "onTargets must not be a function as it ends recursion";
      mapOverTree (cursor: children: value: (
        if isSystem cursor
        then onSytem cursor
        else if isCell cursor
        then onCells cursor
        else if isBlock cursor
        then onBlocks cursor
        else onTargets cursor
      ));
}
