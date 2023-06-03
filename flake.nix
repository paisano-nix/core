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
    lib = l;
    l = nixpkgs.lib // builtins;
    deSystemize = nosys.lib.deSys;
    paths = import ./paths.nix;
    types = import ./types {inherit l yants paths;};

    sprout = args:
      haumea.lib.load {
        src = ./sprout;
        inputs = {inherit haumea lib args;};
      };

    inherit (haumea.lib.transformers) liftDefault;

    registry = args: apex:
      haumea.lib.load {
        src = ./registry;
        inputs = {inherit lib args apex;};
        transformer = liftDefault;
      };

    soil = haumea.lib.load {
      src = ./soil;
      inputs = {inherit lib;};
    };

    exports =
      soil
      // {
        _grow = args: let
          apex = (sprout args).grow;
          reg = registry args apex;
        in
          apex // {__std = reg;};
        inherit (import ./grow {inherit l deSystemize paths types;}) grow growOn;
      };
  in
    exports
    // {
      checks = namaka.lib.load {
        src = ./tests;
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
