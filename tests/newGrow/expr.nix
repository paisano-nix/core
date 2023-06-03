{
  _grow,
  inputs,
}:
_grow {
  inherit inputs;
  cellsFrom = ./__fixture;
  cellBlocks = import ../__cellBlocks.nix inputs;
}
