{
  root,
  haumea,
  cellsFrom,
}: let
  inherit (root) flakeroot loader;
  inherit (haumea.lib.transformers) liftDefault;

  apex = flakeroot rootFor;

  rootFor = system:
    haumea.lib.load {
      src = cellsFrom;
      transformer = liftDefault;
      loader = args:
        loader {
          inherit system;
          inherit apex;
          inherit (args) super root;
        };
    };
in
  apex
