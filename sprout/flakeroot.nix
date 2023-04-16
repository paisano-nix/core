{
  lib,
  systems,
}: f:
lib.foldl (
  toplevel: system:
    toplevel
    // {
      ${system} = f system;
    }
) {}
systems
