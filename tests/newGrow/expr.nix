{
  _grow,
  inputs,
}:
_grow {
  inherit inputs;
  cellsFrom = ./__fixture;
  cellBlocks = [
    {
      name = "test-block";
      type = "test-block-type";
      ci.foo-action = true;
      actions = {
        currentSystem,
        fragment, # sometimes needed when direct invocation on drv is not possible
        fragmentRelPath,
        target,
      }:
        with inputs.nixpkgs.legacyPackages.${currentSystem}; [
          {
            name = "foo-action";
            description = "paisano foo action";
            command = writeShellScript "foo-action-command" ''
              echo "I'm Paisano and 42!"
            '';
          }
        ];
    }
  ];
}
