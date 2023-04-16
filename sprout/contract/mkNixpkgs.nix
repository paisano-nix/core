{root}: let
  inherit (root.api) nixpkgsConfig inputs;
in
  system:
    if nixpkgsConfig != {}
    then
      (import inputs.nixpkgs {
        inherit system;
        config = nixpkgsConfig;
      })
      // {inherit (inputs.nixpkgs) sourceInfo;}
    # numtide/nixpkgs-unfree blocks re-import
    else inputs.nixpkgs.legacyPackages.${system}
