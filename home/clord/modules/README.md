# Home Manager Modules

This directory contains modular home-manager configurations organized by concern.

## Module Structure

### `shell.nix`
- **Purpose**: Shell and terminal configuration
- **Role Required**: `roles.terminal.enable`
- **Includes**:
  - Shell utilities (fish, zsh, bash)
  - Terminal multiplexers (tmux, screen)
  - File navigation tools (fd, fzf, ripgrep)
  - System monitoring (btop, htop)
  - Archive and network tools
- **Imports**: Fish, nushell, direnv, and atuin configurations

### `editor.nix`
- **Purpose**: Text editor configurations
- **Role Required**: `roles.terminal.enable`
- **Includes**:
  - Neovim and Helix configurations
  - Language servers (nixd, nil)
  - Formatters (alejandra, prettier, shfmt)
  - Linters (shellcheck, yamllint)
- **Configuration**: Global `.editorconfig` file

### `development.nix`
- **Purpose**: Programming languages and development tools
- **Role Required**: `roles.development.enable`
- **Language Support**:
  - Go: `roles.development.languages.go`
  - Rust: `roles.development.languages.rust`
  - Node.js: `roles.development.languages.node`
  - Python: `roles.development.languages.python`
- **Includes**: Version control, build tools, debuggers, language servers

### `kubernetes.nix`
- **Purpose**: Kubernetes development and management
- **Role Required**: `roles.kubernetes.enable`
- **Includes**:
  - Core tools (kubectl, helm)
  - Local clusters (kind, k3d, minikube)
  - Development tools (tilt, skaffold)
  - Monitoring (k9s, stern)
- **Configuration**: Shell aliases for common kubectl commands

### `grafana.nix`
- **Purpose**: Grafana-specific development environment
- **Role Required**: `roles.grafana.enable`
- **Includes**:
  - Jsonnet and Tanka
  - Monitoring stack (Prometheus, Loki)
  - Testing tools (k6)
  - Build tools (mage, wire)
- **Configuration**: Git configuration for Grafana repos

## How Modules Work

1. **Role-Based Activation**: Modules check roles to determine if they should be active
2. **Conditional Packaging**: Packages are only installed when their role is enabled
3. **Configuration Management**: Each module manages its own config files and settings
4. **Composability**: Modules can be mixed and matched based on system needs

## Usage

These modules are imported automatically via `modules/default.nix`:

```nix
# In home/clord/waba.nix
{
  imports = [
    ./modules  # Imports all modules
  ];
}
```

Roles are set at the system level in `flake.nix`:

```nix
roles = {
  terminal.enable = true;
  development.enable = true;
  kubernetes.enable = true;
};
```

## Adding New Modules

1. Create a new `.nix` file in this directory
2. Use `config = lib.mkIf roles.<name>.enable` for conditional activation
3. Import the module in `default.nix`
4. Set the corresponding role in system configurations
5. Document the module here

## Best Practices

- One concern per module
- Use roles for activation control
- Keep related configurations together
- Avoid duplication between modules
- Document package inclusions and configurations