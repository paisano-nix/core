{
  args,
  super,
}: let
  inherit (super) types;

  originFlake = "${args.inputs.self.sourceInfo}/flake.nix";
  origin = key: (builtins.unsafeGetAttrPos key args).file or originFlake;

  systems =
    args.systems
    or [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
in {
  inherit
    (args)
    inputs
    cellsFrom
    ;
  systems = types.Systems "${origin "systems"} - grow[On]:systems" systems;
  nixpkgsConfig = args.nixpkgsConfig or {};
}
