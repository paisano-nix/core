/*
This file implements the unique import signature of each block.
*/
{
  l,
  deSystemize,
}: cfg: let
  self = cfg.inputs.self.sourceInfo // {rev = cfg.inputs.self.sourceInfo.rev or "not-a-commit";};
  instantiateNixpkgsWith = system:
    (
      if cfg.nixpkgsConfig != {}
      then
        (import cfg.inputs.nixpkgs {
          inherit system;
          config = cfg.nixpkgsConfig;
        })
      # numtide/nixpkgs-unfree blocks re-import
      else cfg.inputs.nixpkgs.legacyPackages.${system}
    )
    // {inherit (cfg.inputs.nixpkgs) outPath sourceInfo;};
in
  system: cells: additionalInputs: (
    (deSystemize system (cfg.inputs // additionalInputs))
    // {
      inherit self;
      cells = deSystemize system cells; # recursion on cells
    }
    // l.optionalAttrs (cfg.inputs ? nixpkgs) {
      nixpkgs =
        (instantiateNixpkgsWith system)
        //
        # mimick deSystemize behaviour
        (builtins.mapAttrs
          (system: _: instantiateNixpkgsWith system)
          cfg.inputs.nixpkgs.legacyPackages);
    }
  )
