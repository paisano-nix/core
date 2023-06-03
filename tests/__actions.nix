inputs: {
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
]
