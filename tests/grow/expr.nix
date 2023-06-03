{
  grow,
  inputs,
}:
grow {
  inherit inputs;
  cellsFrom = ./__fixture;
  cellBlocks = import ../__cellBlocks.nix inputs;
}
