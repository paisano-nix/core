rec {
  cellPath = cellsFrom: cellName: {
    __toString = _: "${cellsFrom}/${cellName}";
    rel = ''\${cellsFrom}/${cellName}'';
    readme = "${cellsFrom}/${cellName}/Readme.md";
  };
  cellBlockPath = cellPath': cellBlock: {
    __toString = _: "${cellPath'}/${cellBlock.name}";
    file = "${cellPath'}/${cellBlock.name}.nix";
    file' = "${cellPath'.rel}/${cellBlock.name}.nix";
    dir = "${cellPath'}/${cellBlock.name}/default.nix";
    dir' = "${cellPath'.rel}/${cellBlock.name}.nix";
    readme = "${cellPath'}/${cellBlock.name}/Readme.md";
  };
  targetPath = cellsFrom: cellName: cellBlock: let
    cellBlockPath' = cellBlockPath (cellPath cellsFrom cellName) cellBlock;
  in
    name: {
      readme = "${cellBlockPath'}/${name}.md";
    };
}
