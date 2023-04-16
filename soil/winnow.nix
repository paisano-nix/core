{lib}: let
  inherit
    (lib)
    isList
    elemAt
    mapAttrs
    getAttrFromPath
    filterAttrs
    elem
    hasAttrByPath
    foldl'
    recursiveUpdate
    systems
    ;
  /*
  A function that "up-lifts" your `std` targets.

  The transformation is: system.cell.block.target -> system.target

  The results are filtered based on the `pred` function

  You can typically use this function in a compatibility layer of soil.

  Example:

  ```nix
  # Soil ...
  # nix-cli compat
  {
    devShell = inputs.std.winnow (_: v: v != null) inputs.self ["tullia" "devshell" "default"];
    defaultPackage = inputs.std.winnow (n: _: n != "cli") inputs.self ["tullia" "apps" "tullia"];
  }
  ```
  */
  winnow = pred: t: p: let
    multiplePaths = isList (elemAt p 0);
    hoist = path:
      mapAttrs (
        _: v: let
          attr = getAttrFromPath path v;
        in
          # skip overhead if filtering is not needed
          if pred == true
          then attr
          else filterAttrs pred attr
      )
      (
        filterAttrs (
          n: v:
            (elem n systems.doubles.all) # avoids infinit recursion
            && (hasAttrByPath path v)
        )
        t
      );
  in
    if multiplePaths
    then foldl' recursiveUpdate {} (map (path: hoist path) p)
    else hoist p;
in
  winnow
