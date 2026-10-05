# Nix* configurations

This repository contains Nix* configurations for my personal devices.
It isn't meant to be used as a dependency or a template,
but rather to be taken as an inspiration for your own Nix code.

## Usage

In the root of this repository, there is a [`rebuild` script](rebuild) that can be used to rebuild the Nix* configuration.
It switches between `nixos-rebuild` and `darwin-rebuild` depending on the target platform using `uname`.

## License

The contents of this repository is licensed under the MIT license, see [LICENSE](LICENSE).
