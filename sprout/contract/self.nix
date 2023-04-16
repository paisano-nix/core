{inputs}: let
  inherit (inputs.self) sourceInfo;
in
  sourceInfo
  // {
    rev = sourceInfo.rev or "not-a-commit";
  }
