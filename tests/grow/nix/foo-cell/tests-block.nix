{inputs, cell}: {
    inherit (inputs) self;
    cellsNames = builtins.attrNames inputs.cells;
}
