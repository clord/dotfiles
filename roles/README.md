# Roles

This directory contains role definitions that control which features and packages are enabled across the system.

## Overview

Roles provide a high-level way to enable/disable groups of related functionality. They are used throughout the configuration to conditionally include packages, services, and settings.

## Available Roles

### `terminal`
- **Purpose**: Basic terminal and shell tools
- **Enabled by default**: Yes
- **Includes**: Shell utilities, file managers, text processing tools

### `development`
- **Purpose**: General development tools and languages
- **Sub-roles**:
  - `languages.go`: Go development environment
  - `languages.rust`: Rust development environment
  - `languages.node`: Node.js development environment
  - `languages.python`: Python development environment
- **Includes**: Git, build tools, language servers, debuggers

### `kubernetes`
- **Purpose**: Kubernetes development and management tools
- **Options**:
  - `includeHelm`: Include Helm package manager (default: true)
  - `includeK9s`: Include k9s terminal UI (default: true)
- **Includes**: kubectl, kind, k3d, tilt, etc.

### `grafana`
- **Purpose**: Grafana-specific development setup
- **Options**:
  - `includeCloud`: Include Grafana Cloud tools (default: false)
- **Includes**: Jsonnet, Tanka, monitoring stack tools

### `desktop`
- **Purpose**: Desktop environment and GUI applications
- **Sub-roles**:
  - `gaming`: Gaming platforms and tools
  - `multimedia`: Multimedia editing applications

## Usage

Roles are set at the system level in `flake.nix`:

```nix
{
  roles = {
    terminal.enable = true;
    development = {
      enable = true;
      languages = {
        go = true;
        rust = false;
      };
    };
    kubernetes.enable = true;
  };
}
```

Then used in module configurations:

```nix
config = lib.mkIf roles.development.enable {
  home.packages = [ ... ];
};
```

## Adding New Roles

1. Define the role options in `default.nix`
2. Use the role in relevant module configurations
3. Set the role values in system configurations
4. Document the role here

## Best Practices

- Keep roles high-level and user-facing
- Group related functionality together
- Provide sensible defaults
- Use sub-options for fine-grained control
- Document what each role includes