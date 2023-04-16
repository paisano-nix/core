{
  inputs,
  nixpkgsConfig,
}: system:
if nixpkgsConfig != {}
then
  (import inputs.nixpkgs {
    inherit system;
    config = nixpkgsConfig;
  })
  // {inherit (inputs.nixpkgs) sourceInfo;}
# numtide/nixpkgs-unfree blocks re-import
else inputs.nixpkgs.legacyPackages.${system}
