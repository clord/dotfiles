# clord dotfiles

## Structure

- `systems/`
  Configuration for different machines and their supporting services.
- `nixos-modules/`
  Modules that are reusable horizontally.
- `home/`
  Home-manager configuration.
- `secrets/`
  Secret files that are encrypted with agenix.
- `pubkeys/`
  Public user and host keys.

## Installation

Once nix is installed, see the `Makefile` at the root.

## Inspriations

I took some ideas from the following sources:

- [rprospero/dotfiles](https://gitlab.com/rprospero/dotfiles/)
- [thexyno/nixos-config](https://github.com/thexyno/nixos-config)
