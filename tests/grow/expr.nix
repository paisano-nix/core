{
  grow,
  inputs,
}:
grow {
  inherit inputs;
  cellsFrom = ./__fixture;
  cellBlocks = [
    {
      name = "test-block";
      type = "test-block";
      actions = {
        currentSystem,
        fragment, # sometimes needed when direct invocation on drv is not possible
        fragmentRelPath,
        target,
      }:
        with inputs.nixpkgs.legacyPackages.${currentSystem}; [
          {
            name = "foo-action";
            description = "paisano foo";
            command = pkgs.writeShellScript "foo-action" ''
              echo "I'm Paisano and 42!"
            '';
          }
        ];
    }
  ];
}
