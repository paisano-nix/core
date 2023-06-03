{
  nu = "thy";
  da = "thu";
  cells = builtins.attrNames inputs.cells;
  inputs = builtins.attrNames inputs;
  thu = inputs.cells.nu-cell.da;
  thy = scope.nu-cell.nu;
}
