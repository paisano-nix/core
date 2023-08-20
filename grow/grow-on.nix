{
  l,
  grow,
}:
/*
A variant of `paisano.grow` that let's you pass an arbitraty
(variadic) amount of arguments after "growing" the flake.

These arguments are conied "layers of soil" for convenience
and are recursively merged -- in order from top to bottom --
onto the "grown flake output".

Use this facility to implement compatibility layers with
other tooling that expect a certain flake schema.

See `paisano.harvest` for how to level-up outputs conveniently.

Example use:

```nix
{
  inputs = {
    # ...
    std.url = "github:divnix/std";
  };

  outputs = inputs: let
    tasks = import ./nix/std.nix inputs;
    lib = import ./nix/lib.nix inputs;
  in
    inputs.std.growOn {
      inherit inputs;
      cellsFrom = ./cells;
      cellBlocks = [
        # ...
      ];
    }
    # Soil ...
    # nix-cli compat
    {
      devShell = inputs.std.harvest inputs.self ["tullia" "devshell" "default"];
      defaultPackage = inputs.std.harvest inputs.self ["tullia" "apps" "tullia"];
    }
    # dog food
    (lib.fromStd {
      actions = inputs.std.harvest inputs.self ["tullia" "action"];
      tasks = inputs.std.harvest inputs.self ["tullia" "task"];
    })
    # top level tullia outputs
    (lib // {inherit tasks;});
}
```
*/
let
  inherit (builtins) head;
  inherit (builtins) isAttrs;
  inherit (builtins) length;
  inherit (l.lists) elemAt;
  inherit (l.lists) flatten;
  inherit (l.lists) take;

  g = p: l: r: v: let
    attrPath = take 2 p;
    v1 = !(isAttrs l && isAttrs r);
    v2 = if attrPath == ["__std" "ci"] || attrPath == ["__std" "init"] then flatten v else head v;
  in [v1 v2];

  recursiveUpdateUntil =
    g:
    lhs:
    rhs:
    let f = attrPath:
      l.zipAttrsWith (n: values:
      let
        a = g here (elemAt values 1) (head values) values;
        here = attrPath ++ [n];
      in
        if length values == 1 || head a then
          elemAt a 1
        else
          f here values
      );
    in f [] [rhs lhs];
  recursiveUpdate =
    lhs:
    rhs:
    recursiveUpdateUntil g lhs rhs;
in
args:
grow args
// {
  __functor = l.flip recursiveUpdate;
}
