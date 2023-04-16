{lib}: let
  inherit (builtins) hasAttr;
  inherit (lib) isAttrs mapAttrs isFunction;

  /*
  A helper function which hides the complexities of dealing
  with 'system' properly from you, while still providing
  escape hatches when dealing with cross-compilation.
  */
  iteration = cutoff: system: fragment:
    if ! (isAttrs fragment) || cutoff == 0
    then fragment
    else let
      recursed = mapAttrs (_: iteration (cutoff - 1) system) fragment;
    in
      if hasAttr "${system}" fragment
      then
        if isFunction fragment.${system}
        then recursed // {__functor = _: fragment.${system};}
        else recursed // fragment.${system}
      else recursed;
in
  iteration 3
