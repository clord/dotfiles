# Dotfiles Project Context

## Overview
This is a Nix-based dotfiles repository managing configurations for multiple systems using Nix flakes, home-manager, and nix-darwin. The repository supports both NixOS (Linux) and macOS systems with a unified configuration approach.

## Architecture

### Core Technologies
- **Nix Flakes**: Declarative, reproducible system configuration
- **Home Manager**: User environment and dotfiles management
- **nix-darwin**: macOS system configuration management
- **agenix**: Secret management with age encryption

### Repository Structure
```
.
├── flake.nix           # Main flake configuration
├── flake.lock          # Pinned dependencies
├── Makefile            # Build/deploy commands
├── home/               # User-specific configurations
│   ├── clord/          # Primary user config
│   │   ├── common.nix  # Shared across all systems
│   │   ├── darwin-common.nix # macOS shared
│   │   ├── default.nix # Linux default
│   │   ├── waba.nix    # macOS (work machine)
│   │   ├── edmon.nix   # macOS (personal)
│   │   └── programs/   # Program configurations
│   │       ├── cli/    # CLI tools (git, fish, nvim, etc.)
│   │       └── gui/    # GUI applications
│   └── eugene/         # Secondary user config
├── systems/            # System-level configurations
│   ├── common.nix      # Shared system config
│   ├── darwin-common.nix # macOS defaults
│   ├── waba.nix        # Work MacBook (aarch64-darwin)
│   ├── edmon.nix       # Personal MacBook (aarch64-darwin)
│   ├── wildwood.nix    # Desktop Linux (x86_64-linux)
│   ├── dunbar.nix      # Server (aarch64-linux)
│   └── chickenpi.nix   # Raspberry Pi (aarch64-linux)
├── nixos-modules/      # Reusable NixOS modules
├── roles/              # System roles configuration
├── secrets/            # Encrypted secrets (agenix)
├── pubkeys/            # Public SSH keys
├── lib/                # Helper functions
└── xmonad/             # XMonad window manager config
```

## Systems

### macOS Systems (nix-darwin)
- **waba**: Work MacBook Pro (M-series)
  - Development environment for Grafana work
  - Kubernetes/Docker tools
  - 1Password SSH integration
  
- **edmon**: Personal MacBook (M-series)
  - Personal development
  - Similar base config to waba

### NixOS Systems
- **wildwood**: Desktop workstation (x86_64)
  - GNOME desktop environment
  - Dual user setup (clord, eugene)
  - LUKS encryption
  - System76 hardware

- **dunbar**: Server (aarch64)
  - Headless configuration
  - Service hosting

- **chickenpi**: Raspberry Pi (aarch64)
  - Minimal configuration
  - SD card image build
  - RestedPi integration

## Key Features

### Package Management
- Common packages defined in `home/clord/common.nix`
- Platform-specific packages in respective configs
- Development tools in devShell (nixd, nil, statix, alejandra, deadnix)

### Developer Tools
- **Languages**: Go, Rust, Node.js, Python, Zig
- **Kubernetes**: k9s, tilt, helm, kind, k3d
- **Grafana**: Specific tooling for Grafana development
- **Editors**: Neovim (with custom config), Helix

### Shell Environment
- Fish shell with tide prompt
- Custom aliases and functions
- Vi keybindings
- Direnv integration
- Atuin for shell history

### Git Configuration
- Sophisticated git config with aliases
- Conditional includes for work vs personal
- SSH signing with 1Password
- Difftastic for better diffs
- GitHub CLI (gh) integration

## Common Commands

### Building/Switching
```bash
# macOS
make darwin-switch     # Rebuild and switch configuration
nix run nix-darwin -- switch --flake .

# NixOS
make nixos-switch     # Rebuild and switch (requires sudo)
sudo nixos-rebuild switch --flake .

# Remote deployment
make deploy-chickenpi # Deploy to Raspberry Pi

# Development shell
nix develop          # Enter dev shell with tools
```

### Secret Management
```bash
make rekey           # Re-encrypt secrets with agenix
cd secrets && nix run "github:ryantm/agenix" -- -r
```

### Flake Management
```bash
nix flake update     # Update all inputs
nix flake lock --update-input <input>  # Update specific input
nix flake show       # Show flake outputs
```

## Development Workflow

1. **Enter development shell**: `nix develop`
2. **Make changes** to `.nix` files
3. **Check syntax**: `statix check`
4. **Find unused code**: `deadnix`
5. **Format code**: `alejandra .`
6. **Test locally**: `make darwin-switch` or `make nixos-switch`
7. **Commit changes**: Changes are tracked in git

## Configuration Patterns

### Adding a New Package

**See [PACKAGE_ORGANIZATION.md](./PACKAGE_ORGANIZATION.md) for complete guide.**

Quick decision tree:
1. **Role-specific?** (dev tools, k8s, grafana) → `home/clord/modules/*.nix`
2. **Universal CLI utility?** (ripgrep, fzf, wget) → `home/clord/packages/common.nix`
3. **Platform-specific utility?** → `home/clord/packages/{darwin,linux}.nix`

Key principles:
- Role-based modules are preferred over static package lists
- No duplication - each package should be defined once
- Check existing modules before adding to `packages/common.nix`

### Creating a New System
1. Add configuration in `systems/<hostname>.nix`
2. Add to `flake.nix` under appropriate section (darwinConfigurations/nixosConfigurations)
3. Create user home config if needed
4. Update Makefile with deployment command if remote

### Module System
- Roles provide high-level feature flags
- Modules in `nixos-modules/` are reusable components
- Home-manager modules configure user environment

## Important Notes

### Platform Differences
- macOS uses `/Users/` for home directories
- Linux uses `/home/` for home directories
- Some packages are platform-specific (e.g., System76 drivers)
- macOS has additional system defaults configuration

### Security
- Secrets managed with agenix
- SSH keys in `pubkeys/`
- Root password and other sensitive data encrypted
- 1Password integration for SSH on macOS

### Grafana Development
- Conditional git configuration for Grafana repos
- Specialized tooling (jsonnet, tanka, etc.)
- Kubernetes stack for local development

## Troubleshooting

### Common Issues
1. **Flake not found**: Ensure you're in the repository root
2. **Permission denied**: Use `sudo` for NixOS system switches
3. **Out of disk space**: Run `nix-collect-garbage -d`
4. **Broken after update**: Rollback with `nixos-rebuild switch --rollback`

### Useful Commands
```bash
# Check which generation is active
nix-env --list-generations

# Garbage collection
nix-collect-garbage -d

# Check store paths
nix-store --query --roots /nix/store/...

# Verify store integrity
nix-store --verify --check-contents
```

## Future Improvements
- Better modularization of common packages
- More sophisticated role system
- Enhanced secret rotation
- CI/CD for validation
- Better documentation per module