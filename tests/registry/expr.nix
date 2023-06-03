{
  _registry,
  inputs,
}:
_registry {
  inherit inputs;
  cellsFrom = ./__fixture;
  cellBlocks = [
    {
      name = "test-block";
      type = "test-block-type";
      ci.foo-action = true;
      actions = import ../__actions.nix inputs;
    }
  ];
}
