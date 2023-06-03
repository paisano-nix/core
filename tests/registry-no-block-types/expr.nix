{
  _registry,
  inputs,
}:
_registry {
  inherit inputs;
  cellsFrom = ./__fixture;
  systems = ["x86_64-linux"];
  cellBlocks = [];
}
