# Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## [0.2.0](https://github.com/paisano-nix/core/compare/0.1.1..0.2.0) - 2024-02-22
#### Bug Fixes
- also do special nix instantiation for supflake nixpkgs - ([10270dc](https://github.com/paisano-nix/core/commit/10270dc46532c947de473ee88c8f5a3346a396fb)) - [@blaggacao](https://github.com/blaggacao)
- add is dirty predicate that consumes this repo's constant - ([9683ecf](https://github.com/paisano-nix/core/commit/9683ecfbc05f8c86396f0284d7125fe1567cd8d0)) - [@blaggacao](https://github.com/blaggacao)
- add outPath to nixpks to align with any other input - ([9954e48](https://github.com/paisano-nix/core/commit/9954e48e1ebc74a698b9d4ac02aee85514fc0237)) - [@blaggacao](https://github.com/blaggacao)
#### Features
- add support for require args - ([3200ca9](https://github.com/paisano-nix/core/commit/3200ca90ada493ba1b1f190d8c06336162e2d812)) - [@blaggacao](https://github.com/blaggacao)
- implement cell block introspection - ([8025cff](https://github.com/paisano-nix/core/commit/8025cffab28f5ce3ebed74d79a2006f4865afaa2)) - Alex Zero
- add inputs argument to actions - ([f0f5525](https://github.com/paisano-nix/core/commit/f0f5525a4e9713b775fffc592c476df2c857fec0)) - [@blaggacao](https://github.com/blaggacao)
- take cell-level outputs for nix inputs preprocessing - ([13d1901](https://github.com/paisano-nix/core/commit/13d19011d0a327eb514d7493c8696055a6018ca1)) - [@blaggacao](https://github.com/blaggacao)
- add cell-level flake to inject inputs - ([8143561](https://github.com/paisano-nix/core/commit/8143561bf0c4329a94c5bc464cdc15e194575206)) - [@blaggacao](https://github.com/blaggacao)
#### Miscellaneous Chores
- bump devshell nixpkgs - ([9e793f7](https://github.com/paisano-nix/core/commit/9e793f7ea438e1a502d317a90cf172e047f7627b)) - [@blaggacao](https://github.com/blaggacao)
#### Refactoring
- use cursor syntax - ([218a7f5](https://github.com/paisano-nix/core/commit/218a7f50451cbc5c981fc8dfe6f962044041f9aa)) - Alex Zero

- - -

## [0.1.1](https://github.com/paisano-nix/core/compare/0.1.0..0.1.1) - 2023-06-15
#### Bug Fixes
- use new namaka in local flake only - ([694ed3f](https://github.com/paisano-nix/core/commit/694ed3f59f3edf9e2755e560ba1bc34e77979ed5)) - [@blaggacao](https://github.com/blaggacao)

- - -

## [0.1.0](https://github.com/paisano-nix/core/compare/9b95b00f7b4ea1af1d4eb5e09b33cdf8fdc1db44..0.1.0) - 2023-06-03
#### Bug Fixes
- **(README)** typo - ([8bc3f43](https://github.com/paisano-nix/core/commit/8bc3f4328628df114d75974982d2440c0ef11ad1)) - Timothy DeHerrera
- **(README)** standard -> paisano - ([dce0354](https://github.com/paisano-nix/core/commit/dce0354aed9697515f31a00e7dae71faf3b47209)) - Timothy DeHerrera
- the sourceInfo to merge into nixpkgs - ([88f2aff](https://github.com/paisano-nix/core/commit/88f2aff10a5064551d1d4cb86800d17084489ce3)) - guangtao
- make compatible with numtide/nixpkgs-unfree - ([f71a2db](https://github.com/paisano-nix/core/commit/f71a2db9414d66663c03a65ade97a9f353fb6d55)) - [@blaggacao](https://github.com/blaggacao)
- regression where cells wheren't system-spaced anymore - ([63b36b5](https://github.com/paisano-nix/core/commit/63b36b54d5368722e386e16f8e0827dc75165f06)) - [@blaggacao](https://github.com/blaggacao)
- regression over 'nixpkgs'-special-input destystemization - ([2cb985f](https://github.com/paisano-nix/core/commit/2cb985f2df81ad39c2fbfe100e0dfc827964b90e)) - [@blaggacao](https://github.com/blaggacao)
- ci' registry eval error itroduced by refactoring - ([3a37147](https://github.com/paisano-nix/core/commit/3a3714790a58d4f43b74f1756234eb9ca6428836)) - [@blaggacao](https://github.com/blaggacao)
- bad naming and oversights - ([6690cf0](https://github.com/paisano-nix/core/commit/6690cf076a47db643222529c53f41066d6c32e9d)) - [@blaggacao](https://github.com/blaggacao)
#### Continuous Integration
- fix snapshot to pretty print; pretty & avoids flaky reformats - ([0505078](https://github.com/paisano-nix/core/commit/0505078a74819052aa262313e7c0c1cf1ecfecfb)) - [@blaggacao](https://github.com/blaggacao)
- enable GH Action - ([f858648](https://github.com/paisano-nix/core/commit/f858648f18e3a360159e12b75ed0b158e3d5d15f)) - [@blaggacao](https://github.com/blaggacao)
#### Documentation
- reflect schema changes in json schema - ([a73add7](https://github.com/paisano-nix/core/commit/a73add780aa9bd0d61a9b7c3f505c5d45acf7574)) - [@blaggacao](https://github.com/blaggacao)
#### Features
- allow setting metadata in the CI registry - ([5f2fc05](https://github.com/paisano-nix/core/commit/5f2fc05e98e001cb1cf9535ded09e05d90cec131)) - Timothy DeHerrera
- add blockname.md as readme - ([687683a](https://github.com/paisano-nix/core/commit/687683ae1d9028135a43ed1f9cc3954cf55fc689)) - [@blaggacao](https://github.com/blaggacao)
- improve error reporting - ([64026ed](https://github.com/paisano-nix/core/commit/64026ed84100940ecbfbe4056b2f072138155d00)) - [@blaggacao](https://github.com/blaggacao)
- provide actions with the current system - ([8fdf9b1](https://github.com/paisano-nix/core/commit/8fdf9b1e6b21005c0ef4280dbdf3f48cb599a149)) - [@blaggacao](https://github.com/blaggacao)
- add trace verbose on imports - ([143afa3](https://github.com/paisano-nix/core/commit/143afa3083274af3be808687ab23fddbbc9d22ed)) - [@blaggacao](https://github.com/blaggacao)
#### Miscellaneous Chores
- fix typo (thanks for reporting) - ([0ec387f](https://github.com/paisano-nix/core/commit/0ec387f2c2551622b8580b98bea919a395a8c77e)) - [@blaggacao](https://github.com/blaggacao)
- update lock files - ([b83335b](https://github.com/paisano-nix/core/commit/b83335b8018d609903ae4166436f4aa83c275efb)) - [@blaggacao](https://github.com/blaggacao)
- enable cog for real - ([de0a77d](https://github.com/paisano-nix/core/commit/de0a77db4f047ca5cda1fabfcc30b7116fcabdd6)) - [@blaggacao](https://github.com/blaggacao)
- add dev shell and formatters - ([48498b7](https://github.com/paisano-nix/core/commit/48498b74ba33e8ba7e52cbaab68cffbf745333a9)) - [@blaggacao](https://github.com/blaggacao)
- clarify and expand the README - ([c84fa73](https://github.com/paisano-nix/core/commit/c84fa73748b4c2f971bd6ea55e3a26d22eb0d32e)) - Timothy DeHerrera
#### Refactoring
- **(grow)** make ci action's proviso and meta nullable values - ([065db49](https://github.com/paisano-nix/core/commit/065db495e4c131090c4958ca15c7b0d352874aeb)) - [@blaggacao](https://github.com/blaggacao)
- **(grow)** merge ci' into ci as the distinction remained unused so far - ([4b6973d](https://github.com/paisano-nix/core/commit/4b6973d5202aa8b14ea1a35fb45a5f3deb0556f0)) - [@blaggacao](https://github.com/blaggacao)
- simplify local env - ([5475a1e](https://github.com/paisano-nix/core/commit/5475a1ed67ea33ec5cca18a10322aac212d9bf76)) - [@blaggacao](https://github.com/blaggacao)
- remove the debug traced; std check is a better tool - ([81014d0](https://github.com/paisano-nix/core/commit/81014d0a3534de0019d845e07d1e4debf7b7d23f)) - [@blaggacao](https://github.com/blaggacao)
#### Style
- format & lock file - ([7b72870](https://github.com/paisano-nix/core/commit/7b72870291043978a7a5bd2c4912eed8b3a987c7)) - [@blaggacao](https://github.com/blaggacao)
- treefmt - ([bbfe02b](https://github.com/paisano-nix/core/commit/bbfe02b7d2e3b0793973607539fec019086228ae)) - [@blaggacao](https://github.com/blaggacao)
#### Tests
- add snapshot tests for soil function familiy - ([a6b7742](https://github.com/paisano-nix/core/commit/a6b7742bb1e57c910bd76f60f413f04816a0d285)) - [@blaggacao](https://github.com/blaggacao)
- add test instrumentation based on haumea & namaka - ([bd66369](https://github.com/paisano-nix/core/commit/bd66369086d85563a85c61edd99fa74e29aae4ab)) - [@blaggacao](https://github.com/blaggacao)

- - -

Changelog generated by [cocogitto](https://github.com/cocogitto/cocogitto).