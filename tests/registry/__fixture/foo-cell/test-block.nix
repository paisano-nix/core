{
  inputs,
  scope,
}: {
  self = "via foo-cell ${inputs.self}";
  cellsNamesAndSystemsCrossCompilationEscapeHatch = builtins.attrNames inputs.cells;
  barCellBlockNames = builtins.attrNames inputs.cells.bar-cell;
}
