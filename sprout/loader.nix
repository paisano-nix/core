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
    super,
    root,
    system,
    apex,
  }: let
    contract = {
      cell = super;
      inputs =
        mkInputs system
        // {
          inherit self;
          nixpkgs = mkNixpkgs system;
          cells = mkCells root apex;
        };
    };
  in
    lib.flip lib.pipe [
      (lib.scopedImport contract)
      (lib.toFunction) # may be a set
      (f: f contract) # or has contract signature
    ]
