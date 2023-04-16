{
  root,
  lib,
  haumea,
}: let
  inherit
    (root.contract)
    self
    mkInputs
    mkNixpkgs
    mkCells
    ;
  inherit (haumea.lib.loaders) verbatim;
in
  {
    cell,
    cells',
    system,
    toplevel,
  }: let
    contract = {
      inherit cell;
      inputs =
        mkInputs system
        // {
          inherit self;
          nixpkgs = mkNixpkgs system;
          cells = cells' // (mkCells toplevel);
        };
    };
  in
    lib.flip lib.pipe [
      (lib.scopedImport contract)
      (lib.toFunction) # may be a set
      (f: f contract) # or has contract signature
    ]
