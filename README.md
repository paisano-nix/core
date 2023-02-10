<!--
SPDX-FileCopyrightText: 2022 The Standard Authors

SPDX-License-Identifier: Unlicense
-->

# Divnix Paisano

_Organize your Flakes-based projects_

Paisano implements an API for organizing Nix code into folders.

It then maps that folder structure into Flake outputs, once per system.

To type outputs, an output type system is provided and traits (i.e. "abstract behaviour") may be implemented on them.

## Motivation

Nix flakes make it easy to create self-contained projects with a common top-level interface that has been standardized througout the Nix Community.
However, as an upstream standard it was built (mostly) for the packaging use case of Nix in the context of small package-centric repositories.
It is, therefore, less suited for a DevOps centric usage pattern.

With Paisano, we attempt to solve the following problems:

- **Internal code boundaries**:
  Nix isn't typed and doesn't itself impose any opinion on how to organize code.
  It also doesn't define a module system in the same sense as a typical programming language, in which modules are often folder-based encapsulation of functionality.
  
  Therefore, Nix forces its users to make a significant upfront investment in designing their code layout.
  Unfortunately, due to the planning overhead that this entails, many users may just skip out on Nix for this reason alone.
  Over longer time horizons, Nix code seen in the wild tends, in our experience, to lose clarity and organization.
  
  Paisano addresses this problem by simple, clear, and extensible calling conventions on its module importer interface.

- **Ease of refactoring**:
  In many a Nix codebase, a multiplicity of interaces, coupled with needlessly bespoke calling conventions make semantic code refactoring unnecessarily difficult.
  
  In contrast, Paisano enforces a single, but powerful, calling convention for its importer. As a result, Paisano makes semantic refactoring straightforward as your project naturally grows.

- **Shared mental structure**:
  A custom code structure often comes with a hefty price tag in terms of context switching between projects.
  Yet, in a typical DevOps workflow, it is not uncommon to deal with multiple, diverse code bases.
  
  By encouraging basic organizational principles (at least) in your (Nix) code, a future "self" or present "other" will be able to significantly lower their cognitive load,
  leaving more time to get useful work done.

  
- **Take out the guesswork**:
  The costs of the upfront design work required to effectively structure your project, along with the above mentioned hurdles in code refactoring are simply too high.
  And if that's not bad enough, the cost of making a mistake during this process is _even higher_, leading to more tedious work simply to make sense out of your existing code.
  
  As a consequence, many (Nix) projects evolve unguided, with the heavy price of refactoring postponed.
  This can quickly become a vicious cycle of ever growing spaghetti code, which is then more and more difficult to refactor as time goes on.
  
  Paisano's meta-structure alleviates the guesswork considerably, enabling the user to spend their time creating a meaningful project type system.
  It is this very system which allows time to focus on effectively solving your problem; the solution of which can then be mapped effortlessly over any related outputs, again and again.

  In short, considerable effort is expended to take the previously destructive feedback loop described above, and turn it into a highly productive one; allowing for quick _and_ correct (i.e. well-typed) iteration.
  
- **Avoid level-creep**:
  There is often a tension between depth and breadth when organizing the folder structure of your project.
  A deeply nested scheme may sometimes map the problem domain more efficiently, but it isn't necessarily optimized for human consumption.
  
  Paisano tries to find a nice balance, which readily accomodates every problem domain without compromising readability.

  We do this by offering an unambiguous model for structuring your code, which breaks down fairly simply as follows.

  ### When you want:
  - Breath &#8594; add a code block
  - Depth &#8594; compose flakes

  This creates a natural depth boundary at the repository level, since it is generally considered good practive to use one flake per project repository.

## Terminology

- **Cells** &mdash; they are the first level in the folder structure and group related functionality together.
  An example from the microserivce use case would be a backend cell or a frontend cell.
   
- **Block** &mdash; the next level in the folder structure are (typed) blocks that implement a collection of similar functionality, i.e. code modules (in other languages).
  One could be labeled "tasks", another "packages", another "images", etc.

- **Targets** &mdash; each block type can have one or more targets.
  These are your concrete packages, container images, scripts, etc.

- **Block Types & Actions** &mdash;
  These are the types attached to the blocks mentioned above. They allow you to define arbitary actions which can be run over the specific targets contained in the associated block.
  This allows a platform or framework provider to implement shared functionality for their particular use case, such as a single action which describes how to "push" container images to their registry.

  This is really where Paisano breaks away from the simple packaging pattern of Nix and allows you to define what you actually want to _do_ with those packages, artifacts, scripts, or images in a well-defined, boilerplate free way.

- **Registry** &mdash; the registry extracts structured, yet json-serializable, data from our output type system and code structure.
  Consumers such as CI, a CLI/TUI, or even a UI can access and extract that data for a tight integration with the respective target use cases. For a concrete example of a consumer, see [std-action](https://github.com/divnix/std-action).
  

## Regsitry Schema Spec

The current schema version is `v0` (unstable).

The Jsonschema specification of the registry can be found inside [`./registry.schema.json`](./registry.schema.json).
It can be explored interactively with this [link][explore-registry-schema].

[explore-registry-schema]: https://json-schema-viewer.vercel.app/view?url=https%3A%2F%2Fraw.githubusercontent.com%2Fdivnix%2Fpaisano%2Fmain%2Fregistry.schema.json&description_is_markdown=on&expand_buttons=on&show_breadcrumbs=on&with_footer=on&template_name=js

## Usage

```nix
# flake.nix
{
  inputs.paisano.url = "github:divnix/paisano";
  inputs.paisano.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { paisano, self }@inputs: 
    paisano.growOn {
      /* 
        the grow function needs `inputs` to desystemize
        them and make them available to your cell blocks
      */
      inherit inputs;
      /* 
        sepcify from where to grow the cells
        `./nix` is a typical choice that signals
        to everyone where the nix code lies
      */
      cellsFrom = ./nix;
      /*
        These blocks may or may not be found in a particular cell.
        But blocks that aren't defined here, cannot exist in any cell.
      */
      cellBlocks = [
        {
          /*
            Because the name is `mycellblock`, paisano's importer
            will be hooking into any file `<cell>/mycellblock.nix`
            or `<cell>/mycellblock/default.nix`.
            Block tragets are exposed under:
            #<system>.<cell>.<block>.<target>
          */
          name = "mycellblock";
          type = "mytype";

          /*
            Optional
            
            Actions are exposed in paisano's "registry" under
            #__std.actions.<system>.<cell>.<block>.<target>.<action>
          */
          actions = {
            system,
            flake,
            fragment,
            fragmentRelPath,
          }: [
            {
              name = "build";
              description = "build this target";
              command = ''
                nix build ${flake}#${fragment}
              '';
            }
          ];
          /*
            Optional
            
            The CI registry flattens the targets and
            the actions to run for each target into a list
            so that downstream tooling can discover what to
            do in the CI. The invokable action is determined
            by the attribute name: ci.<action> = true

            #__std.ci.<system> = [ {...} ... ];
          */
          ci.build = true;
        }
      ];
    }
    {
      /* Soil */
      # Here, we make our domain layout compatible with the Nix CLI, among others
      devShells = paisano.harvest self [ "<cellname>" "<blockname>"];
      packages = paisano.winnow (n: v: n == "<targetname>" && v != null ) self [ "<cellname>" "<blockname>"];
      templates = paisano.pick self [ "<cellname>" "<blockname>"];
    };
}
```
