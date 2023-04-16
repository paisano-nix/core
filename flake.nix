# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
{
  inputs.nosys.url = "github:divnix/nosys";
  inputs.haumea = {
    url = "github:nix-community/haumea";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.namaka = {
    url = "github:nix-community/namaka";
    inputs.haumea.follows = "haumea";
  };
  inputs.yants = {
    url = "github:divnix/yants";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    nixpkgs,
    haumea,
    namaka,
    nosys,
    yants,
    self,
  }: let
    l = nixpkgs.lib // builtins;
    deSystemize = nosys.lib.deSys;
    paths = import ./paths.nix;
    types = import ./types {inherit l yants paths;};
    exports = {
      inherit _grow;
      inherit (import ./soil {inherit l;}) pick harvest winnow;
      inherit (import ./grow {inherit l deSystemize paths types;}) grow growOn;
    };
  in
    exports
    // {
      checks = namaka.lib.load {
        flake = self;
        inputs =
          exports
          // {
            # simulate 'inputs'
            inputs = {
              inherit nixpkgs;
              self.sourceInfo = {
                outPath = "constant-self";
                rev = "constant-rev";
              };
            };
          };
      };
    };
}
