{args}: {
  inherit
    (args)
    inputs
    cellsFrom
    cellBlocks
    ;
  systems =
    args.systems
    or [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  nixpkgsConfig = args.nixpkgsConfig or {};
}
