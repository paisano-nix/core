{
  inputs,
  cell,
}: {
  inherit (inputs.cells.foo-cell.test-block) self;
}
