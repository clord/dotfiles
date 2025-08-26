# CLI Programs

This directory contains configurations for command-line tools and applications.

## Program Configurations

### Shell & Terminal

#### `fish.nix`
- **Purpose**: Fish shell configuration
- **Features**:
  - Tide prompt theme
  - Vi key bindings
  - Custom functions (t, mcd)
  - Git abbreviations
  - System management functions

#### `nushell.nix`
- **Purpose**: Nushell configuration
- **Features**: Modern shell with structured data

#### `direnv.nix`
- **Purpose**: Directory-based environment management
- **Features**: Auto-load `.envrc` files, nix-direnv integration

#### `atuin.nix`
- **Purpose**: Enhanced shell history
- **Features**: Sync, search, and manage shell history

### Text Editors

#### `nvim/`
- **Purpose**: Neovim configuration
- **Features**: Full IDE setup with LSP, tree-sitter, plugins

#### `helix.nix`
- **Purpose**: Helix editor configuration
- **Features**: Modern modal editor with built-in LSP

### Development Tools

#### `git.nix`
- **Purpose**: Git version control configuration
- **Features**:
  - User configuration
  - SSH signing with 1Password
  - Conditional includes for work repos
  - Extensive aliases
  - Difftastic integration

#### `ssh.nix`
- **Purpose**: SSH client configuration
- **Features**: Host configurations, key management

### File Management

#### `eza.nix`
- **Purpose**: Modern ls replacement
- **Features**: Colors, icons, git integration

#### `bat.nix`
- **Purpose**: Enhanced cat with syntax highlighting
- **Features**: Themes, line numbers, git integration

#### `btop.nix`
- **Purpose**: System resource monitor
- **Features**: CPU, memory, disk, network monitoring

## Configuration Pattern

Each configuration file follows this pattern:

```nix
{ config, lib, pkgs, roles, ... }:
{
  programs.toolname = {
    enable = roles.terminal.enable;
    # Tool-specific settings
    settings = { ... };
  };
  
  # Additional configuration
  home.packages = [ ... ];
}
```

## Adding New CLI Tools

1. Create `programs/cli/<tool>.nix`
2. Configure the program using home-manager options
3. Import in `programs/cli/default.nix` or relevant module
4. Set role requirements if needed
5. Document the configuration here

## Best Practices

- Use home-manager's built-in program modules when available
- Keep configurations modular and focused
- Use roles to control enablement
- Document key features and customizations
- Test configurations before committing

## Tips

- Check `home-manager` options: `man home-configuration.nix`
- Use `mkIf` for conditional configuration
- Leverage existing dotfiles with `home.file`
- Keep sensitive data in agenix secrets