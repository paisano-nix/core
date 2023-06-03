/*
This file implements aggregation helper for collecting blocks.
*/
{l}: {
  accumulate =
    l.foldl'
    (
      acc: new: let
        first = l.head new;
        second = l.head cdr;
        third = l.head cdr';
        tail = l.tail cdr';

        cdr = l.tail new;
        cdr' = l.tail cdr;
      in
        (
          if first == null
          then {inherit (acc) output;}
          else {output = acc.output // first;}
        )
        // (
          if second == null
          then {inherit (acc) actions;}
          else {actions = acc.actions // second;}
        )
        // (
          if third == null
          then {inherit (acc) init;}
          else {init = acc.init ++ [third];}
        )
        // (
          if tail == [null]
          then {inherit (acc) ci;}
          else {ci = acc.ci ++ (l.concatMap (t: l.flatten t.ci) tail);}
        )
    )
    {
      output = {};
      actions = {};
      init = [];
      ci = [];
    };

  optionalLoad = cond: elem:
    if cond
    then elem
    else [
      null # empty output
      null # empty action
      null # empty init
      null # empty ci
    ];
}
