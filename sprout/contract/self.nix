{root}: let
  inherit (root.api.inputs.self) sourceInfo;
in
  sourceInfo
  // {
    rev = sourceInfo.rev or "not-a-commit";
  }
