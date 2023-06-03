# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
{
  inputs.haumea = {
    url = "github:nix-community/haumea/v0.2.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.yants = {
    url = "github:divnix/yants";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    nixpkgs,
    haumea,
    yants,
    self,
  }: let
    inherit (haumea.lib) load;
    inherit (haumea.lib.transformers) liftDefault;

    lib = nixpkgs.lib // builtins;
    sprout = args:
      load {
        src = ./sprout;
        inputs = {inherit haumea lib args yants;};
        transformer = liftDefault;
      };
    registry = args: apex:
      load {
        src = ./registry;
        inputs = {inherit lib args apex yants;};
        transformer = liftDefault;
      };
    soil = load {
      src = ./soil;
      inputs = {inherit lib;};
    };
  in
    soil
    // rec {
      grow = args: let
        apex = (sprout args).grow;
        reg = registry args apex;
      in
        apex // {__std = reg;};
      growOn = import ./grow-on.nix {inherit lib grow;};
    };
}
