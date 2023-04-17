{lib}: let
  inherit (lib) mapAttrs toFunction length;
  /*
  mapAttrsRecursive: walks the tree with a preticate map function
  to find transform functions based on cursor and / or value. If
  the prediacte map returns a constant function, then stop recursing,
  else pass the results of recursion as its first argument.

  Type:
    mapAttrsRecursive :: (
      [ String ] -> a -> ((r -> b) | b)
    ) -> AttrSet -> c

  Example:
    mapAttrsRecursive (cursor: value:
      if last cursor == "myattribute" && isAttrs value
      then children: value // {
          name = head cursor;
          inherit children;
      }
      else "I'm the end"
    ) {
      myattribute = { # isAttrs ---------^^^^^^^
        bar = "bar";
      };
    } => {
      name = "myattribute";
      bar = "bar";
      children = "I'm the end";
    }
  */
in
  func: let
    recurse = path:
      mapAttrs (name: value: let
        result = func (path ++ [name]) value;
        children = recurse (path ++ [name]) value;
      in
        toFunction result children);
  in
    recurse []
