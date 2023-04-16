{
  root,
  haumea,
  cellsFrom,
}: let
  inherit (root) forEachSystem loader;
  inherit (haumea.lib) load;
  inherit (haumea.lib.transformers) liftDefault;

  toplevel = forEachSystem (
    system:
      load {
        src = cellsFrom;
        transformer = liftDefault;
        loader = args:
          loader {
            inherit system;
            inherit toplevel;
            cell = args.super;
            cells' = args.root;
          };
      }
  );
in
  toplevel
