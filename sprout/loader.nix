{
  root,
  lib,
  haumea,
}: let
  inherit (root) types;
  inherit
    (root.contract)
    self
    mkInputs
    mkNixpkgs
    mkCells
    ;
in
  {
    super,
    root,
    system,
    apex,
  }: let
    contract = {
      scope = super;
      inputs =
        mkInputs system
        // {
          inherit self;
          nixpkgs = mkNixpkgs system;
          cells = mkCells root apex;
        };
    };
  in
    path:
      lib.pipe path [
        (lib.scopedImport contract)
        (types.Scope "paisano/import: ${toString path}")
        (lib.toFunction) # may be a set
        (f: f contract) # or has contract signature
      ]
