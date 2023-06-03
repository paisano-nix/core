{
  _registry,
  inputs,
}:
_registry {
  inherit inputs;
  cellsFrom = ./__fixture;
  systems = ["x86_64-linux" "aarch64-linux"];
  cellBlocks = [
    {
      name = "block";
      type = "block-type";
      ci.foo-action = true;
      actions = import ../__actions.nix inputs;
    }
  ];
}
