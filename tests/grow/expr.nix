{grow, inputs}: let
in grow {
    inherit inputs;
    cellsFrom = ./nix;
    blockTypes = [
        {name = "tests-block"; type = "tests-block";}
    ];
};

