{
  inputs,
  cell,
}: {
  self = "foo-cell ${inputs.self}";
  cells = builtins.attrNames inputs.cells;
  barCell = builtins.attrNames inputs.cells.bar-cell;
}
