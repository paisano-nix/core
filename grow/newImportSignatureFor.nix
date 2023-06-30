/*
This file implements the unique import signature of each block.
*/
{
  l,
  deSystemize,
}: cfg: let
  self = cfg.inputs.self.sourceInfo // {rev = cfg.inputs.self.sourceInfo.rev or "not-a-commit";};
  instantiateNixpkgsWith = system: nixpkgs:
    (
      if cfg.nixpkgsConfig != {}
      then
        (import nixpkgs {
          inherit system;
          config = cfg.nixpkgsConfig;
        })
      # numtide/nixpkgs-unfree blocks re-import
      else nixpkgs.legacyPackages.${system}
    )
    // {inherit (nixpkgs) outPath sourceInfo;};
in
  system: cells: additionalInputs: let
    currentNixpkgs =
      if additionalInputs ? nixpkgs
      then additionalInputs.nixpkgs
      else if cfg.inputs ? nixpkgs
      then cfg.inputs.nixpkgs
      else null;
  in (
    (deSystemize system (cfg.inputs // additionalInputs))
    // {
      inherit self;
      cells = deSystemize system cells; # recursion on cells
    }
    // l.optionalAttrs (currentNixpkgs != null) {
      nixpkgs =
        (instantiateNixpkgsWith system currentNixpkgs)
        //
        # mimick deSystemize behaviour
        (builtins.mapAttrs
          (system: _: instantiateNixpkgsWith system currentNixpkgs)
          currentNixpkgs.legacyPackages);
    }
  )
