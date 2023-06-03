{
  description = "Paisano Core development shell";
  inputs.nosys.url = "github:divnix/nosys";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.namaka = {
    url = "github:nix-community/namaka/v0.2.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.devshell.url = "github:numtide/devshell";
  inputs.call-flake.url = "github:divnix/call-flake";
  outputs = inputs @ {
    nosys,
    call-flake,
    ...
  }:
    nosys ((call-flake ../.).inputs // inputs) (
      {
        self,
        namaka,
        nixpkgs,
        devshell,
        ...
      }:
        with nixpkgs.legacyPackages;
        with nixpkgs.legacyPackages.nodePackages;
        with devshell.legacyPackages; let
          inherit (lib.stringsWithDeps) noDepEntry;
          checkMod = {
            commands = [{package = treefmt;}];
            packages = [alejandra shfmt prettier prettier-plugin-toml];
            devshell.startup.nodejs-setuphook = noDepEntry ''
              export NODE_PATH=${prettier-plugin-toml}/lib/node_modules:$NODE_PATH
            '';
          };
        in {
          devShells = {
            check = mkShell {
              name = "Paisano Core (Check)";
              imports = [checkMod];
            };
            default = mkShell {
              name = "Paisano Core";
              imports = [checkMod];
              commands = [
                {package = namaka.packages.default;}
                {
                  package = cocogitto;
                  name = "cog";
                }
              ];
            };
          };

          checks = namaka.lib.load {
            src = ../tests;
            inputs =
              {
                inherit
                  (call-flake ../.)
                  # soil
                  
                  winnow
                  harvest
                  pick
                  # grow
                  
                  grow
                  growOn
                  ;
              }
              # simulate 'inputs'
              // {
                inputs = {
                  inherit nixpkgs;
                  self.sourceInfo = {
                    outPath = "constant-self";
                    rev = "constant-rev";
                  };
                };
              };
          };
        }
    );
}
