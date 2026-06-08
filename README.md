# ferdium-app-flake

> **Note**: This repository was generated with [opencode](https://opencode.ai) — an AI coding assistant.

[![Nix Flake](https://img.shields.io/badge/Nix-Flake-blue?logo=nixos&color=5277C3)](https://nixos.org)

Nix flake for [Ferdium](https://ferdium.org) — all your messaging services in one place.

## Usage

### Run directly

```bash
nix run github:emilysoft/ferdium-app-flake
```

### Build

```bash
nix build github:emilysoft/ferdium-app-flake
```

### Use as flake input

```nix
{
  inputs = {
    ferdium.url = "github:emilysoft/ferdium-app-flake";
  };

  outputs = { self, nixpkgs, ferdium, ... }: {
    nixosConfigurations.myMachine = nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.overlays = [ ferdium.overlays.default ]; }
      ];
    };
  };
}
```

### Local path (for development)

```nix
ferdium.url = "path:/path/to/ferdium-app-flake";
```

## Updating

```bash
./nix/update.sh
```

Fetches the latest stable release from GitHub and updates version + hashes.

## Supported platforms

- `x86_64-linux`
- `aarch64-linux`

## Upstream

- [ferdium/ferdium-app](https://github.com/ferdium/ferdium-app)
- [ferdium.org](https://ferdium.org)
