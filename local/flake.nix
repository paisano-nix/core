{
  description = "Paisano Core development shell";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.main.url = "path:../.";
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    eachSystem = f:
      lib.genAttrs
      lib.systems.flakeExposed
      (system:
        f (
          inputs.nixpkgs.legacyPackages.${system}.appendOverlays [inputs.devshell.overlays.default]
          // {namaka = inputs.main.inputs.namaka.packages.${system}.default;}
        ));
    inherit (lib.stringsWithDeps) noDepEntry;
  in {
    devShells = eachSystem (pkgs: let
      checkMod = {
        commands = [{package = pkgs.treefmt;}];
        packages = [
          pkgs.alejandra
          pkgs.shfmt
          pkgs.nodePackages.prettier
          pkgs.nodePackages.prettier-plugin-toml
        ];
        devshell.startup.nodejs-setuphook = noDepEntry ''
          export NODE_PATH=${
            pkgs.nodePackages.prettier-plugin-toml
          }/lib/node_modules:$NODE_PATH
        '';
      };
    in {
      check = pkgs.devshell.mkShell {
        name = "Paisano Core (Check)";
        imports = [checkMod];
      };
      default = pkgs.devshell.mkShell {
        name = "Paisano Core";
        imports = [checkMod];
        commands = [
          {package = pkgs.namaka;}
          {
            package = pkgs.cocogitto;
            name = "cog";
          }
        ];
      };
    });
  };
}
