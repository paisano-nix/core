{
  _registry,
  inputs,
}:
(_registry {
  inherit inputs;
  cellsFrom = ./__fixture;
  systems = ["x86_64-linux"];
  cellBlocks = [
    {
      name = "block";
      type = "block-type";
      actions = import ../__actions.nix inputs;
    }
  ];
})
.ci
