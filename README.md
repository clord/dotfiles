# clord's dotfiles

## Structure

- `systems/`
  Configuration for different machines and their supporting services.
- `nixos-modules/`
  Modules that are reusable horizontally.
- `home/`
  Home-manager configuration.
- `secrets/`
  Secret files that are encrypted with [agenix](https://github.com/ryantm/agenix).
- `pubkeys/`
  Public user and host keys.

## Installation

- install non-determinate nix (can use installer but use plain nix)

Once nix is installed, see the `Makefile` at the root.

## Inspriations

I took some ideas from the following sources:

- [rprospero/dotfiles](https://gitlab.com/rprospero/dotfiles/)
- [thexyno/nixos-config](https://github.com/thexyno/nixos-config)
- [calops/nix](https://github.com/calops/nix)

## Plans

- [ ] Use for my Homelab server, including [containerization](https://www.tweag.io/blog/2020-07-31-nixos-flakes/)
- [ ] nix-ize my [Grafana setup](https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/)
- [ ] port over favorite [macos options to nix-darwin](https://github.com/LnL7/nix-darwin/blob/master/modules/examples/lnl.nix).
