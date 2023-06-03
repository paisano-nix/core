{
  _grow,
  grow,
  inputs,
}: let
  old = import ../grow/expr.nix {inherit grow inputs;};
  new = import ../newGrow/expr.nix {inherit _grow inputs;};
in {
  actions = old.__std.actions == new.__std.actions;
  init = old.__std.init == new.__std.init;
  ci = old.__std.ci == new.__std.ci;
  cellsFrom = old.__std.cellsFrom == new.__std.cellsFrom;
  schema = old.__std.__schema == new.__std.__schema;
  aarch64-darwin = old.aarch64-darwin == new.aarch64-darwin;
  aarch64-linux = old.aarch64-linux == new.aarch64-linux;
  x86_64-darwin = old.x86_64-darwin == new.x86_64-darwin;
  x86_64-linux = old.x86_64-linux == new.x86_64-linux;
}
