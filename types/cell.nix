{
  l,
  cellPath,
  cellBlockPath,
}: originFlake: cellsFrom: cellBlocks: cell: type: let
  path = cellBlockPath (cellPath cellsFrom cell);
  atLeastOneCellBlock = l.any (x: x) (
    l.map (
      o: l.pathExists (path o).file || l.pathExists (path o).dir
    )
    cellBlocks
  );
  cellsFrom' = "${l.baseNameOf cellsFrom}";

  maxLenght = list:
    builtins.foldl' (max: v:
      if v > max
      then v
      else max)
    0
    list;

  cellBlockNameLength = map ({name, ...}: builtins.stringLength name) cellBlocks;
  maxCellBlockNameLength = maxLenght cellBlockNameLength;

  cellBlockTypeLength = map ({type, ...}: builtins.stringLength type) cellBlocks;
  maxCellBlockTypeLength = maxLenght cellBlockTypeLength;

  pad = str: num:
    if num > 0
    then pad "${str} " (num - 1)
    else str;
  padl = str: num:
    if num > 0
    then padl " ${str}" (num - 1)
    else str;
in
  if type != "directory"
  then
    abort ''

      Not a Cell:       ${cellsFrom}/${cell}
      Containing Flake: ${originFlake}

      Everything at the first level under ${cellsFrom'}/* is a Cell.
      Cells are directories by convention.
      Hence, only directories are allowed at ${cellsFrom'}/*

      Please remove: `rm ${cellsFrom'}/${cell}'
      Important:     `git add ${cellsFrom'}/${cell}'
    ''
  else if !atLeastOneCellBlock
  then
    abort ''

      Missing Cell Block: ${cellsFrom}/${cell}
      Containing Flake:   ${originFlake}

      This Cell must provide at least one Cell Block.
      In this project, the Cell Blocks may be:
        - ${l.concatStringsSep "\n  - " (l.map (o: "${o.name}") cellBlocks)}


      ${
        l.concatStringsSep "\n" (
          l.map (
            cellBlock: let
              padName = maxCellBlockNameLength - (builtins.stringLength cellBlock.name);
              padType = maxCellBlockTypeLength - (builtins.stringLength cellBlock.type);
              title = "For Block ${padl cellBlock.name padName} of type ${pad cellBlock.type padType} create: ";
              paths = "${pad (path cellBlock).file' padName} or ${(path cellBlock).dir'}";
            in
              title + paths
          )
          cellBlocks
        )
      }

      When done, don't forget:
        `git add ${cellsFrom'}/${cell}'
    ''
  else cell
