{
  growOn,
  harvest,
  winnow,
  pick,
  inputs,
}: let
  self = growOn {
    inherit inputs;
    cellsFrom = ./__fixture;
    cellBlocks = [
      {
        name = "foo-block";
        type = "another type";
      }
      {
        name = "templates";
        type = "a type";
      }
    ];
  };
in
  # Soil
  {
    foo = harvest self ["foo-cell" "foo-block"];
    fooAndBar = harvest self [
      ["foo-cell" "foo-block"]
      ["bar-cell" "foo-block"]
    ];
    fooAndBar' = winnow (n: v: n == v) self [
      ["foo-cell" "foo-block"]
      ["bar-cell" "foo-block"]
    ];
    libToplevel = harvest self ["foo-cell"];
    libToplevelAndHoistedChildren = harvest self [
      ["foo-cell"]
      ["foo-cell" "foo-block"]
    ];
    templates = pick self ["bar-cell" "templates"];
  }
