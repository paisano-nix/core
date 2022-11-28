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
However, as an upstream standard, it was built (mostly) for the packaging use case of Nix in the context of small package-centric repositories.
It therefore is less suited for a DevOps centric usage pattern of Nix.

With Paisano, we attempt to solve the following problems:

- **Internal code boundaries**:
  Nix isn't typed and doesn't itself impose any opinion on how to organize code.
  It also doesn't know a module system in the sense of a classical programming language, in which modules are often folder-based encapsulation of functionality.
  
  Therefore, Nix forces its users to make a significant upfront investment in designing theri code layout.
  Unfortunately, due to the planning overhead that this entails, many users won't choose to do that.
  Over longer time horizons, Nix code seen in the wild tends in our experience to loose clarity and organization.
  
  Paisano addresses this problem by simple, clear, yet extensible, calling conventions on its module importer interface.

- **Ease of refactoring**:
  Multiplicity of interaces and needlessly bespoke calling conventions make semantic code refactoring unnecessarily hard.
  
  By enforcing a single, but powerful, calling convention for its importer and as a project grows, Paisano makes semantic refactoring as straigth forward as possible.

- **Shared mental structure**:
  A bespoke code structure often comes with a hefty price tag in context switching costs.
  Hoverer, in a DevOps scenario, it is not uncommon to deal with multiple and very diverse code bases.
  
  By encouraging basic organizational principles (at least) in your (Nix) code, a future "self" or present "other" will be able to significantly lower their context switching costs.
  
- **Take out the guesswork**:
  The cost of upfront design work in properly structuring your project combined with the above mentioned hurdles to refactoring are a high stake.
  
  As a consequence, many projects evolve unguided and refactorings are postponed due to the effort they involve.
  
  Paisano's meta-structure takes out the guesswork as much as possible while encouraging its users to think about their project's internal type system.
  
- **Avoid level-creep**:
  There is a tension between depth and breadth when organizing folder structures.
  A deeply nested folder structure may be sometimes closer modeled after the problem domain.
  However, a deeply nested folder sturcure isn't necessarily optimized for human consumption.
  
  Paisano tries to find a balance between breadth and depth that readily accomodates every problem domain, yet doesn't compromise on readability.

## Terminology

- **Cells** &mdash; they are the first level in the folder structure and group related functionality together.
  An example from the microserivce use case would be a backend cell or a frontend cell.
   
- **Block** &mdash; the next level in the folder structure are (typed) blocks that implement a collection of similar functionality.
  An example, again from the microservice use case, would be several package and container variants for the backend.

- **Targets** &mdash; each block type can have one or more targets.
  For example, one or more container images or one or more packages.

- **Block Types & Actions** &mdash; blocks are typed.
  This allows for example a platform or framework provider to implement shared functionality for their use cases.
  That way, use case specific type systems can be implemented for example by platform engineers.

- **Registry** &mdash; the registry extracts structured, yet json-serializable, data from our output type system and code structure.
  Consumers such as CI, a CLI/TUI, or even a UI can access and extract that data for a tight integration with the respective target use cases.
  

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
