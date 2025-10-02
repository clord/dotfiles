# Package Organization Guide

## Overview

This dotfiles repository uses a **role-based package management** system to avoid duplication and maintain clear separation of concerns. Understanding where to add packages is crucial for maintaining the codebase.

## Architecture

### Package Locations

```
home/clord/
├── packages/           # Static package lists (minimal, universal utilities only)
│   ├── common.nix     # Truly universal CLI tools (all systems)
│   ├── darwin.nix     # macOS-only utilities
│   └── linux.nix      # Linux-only utilities
├── modules/           # Role-based, dynamic package management
│   ├── development.nix  # All development tools & languages
│   ├── kubernetes.nix   # K8s ecosystem tools
│   ├── grafana.nix      # Grafana-specific tools
│   ├── server.nix       # Server management tools
│   ├── editor.nix       # Editor configurations
│   └── shell.nix        # Shell enhancements
└── ssh-configs/       # SSH configuration by host
    ├── darwin-base.nix    # Base macOS SSH setup
    └── waba-github.nix    # Host-specific SSH configs
```

## Decision Tree: Where to Add a Package

### Step 1: Is it role-specific?

**YES → Use `home/clord/modules/*.nix`**

- **Development tools** (git, compilers, linters, formatters) → `modules/development.nix`
- **Kubernetes tools** (kubectl, helm, k9s, argocd) → `modules/kubernetes.nix`
- **Grafana tools** (jsonnet, tanka, k6) → `modules/grafana.nix`
- **Server tools** (docker, podman, monitoring) → `modules/server.nix`

**NO → Continue to Step 2**

### Step 2: Is it a universal CLI utility?

**YES → Use `home/clord/packages/common.nix`**

Examples of universal utilities:
- Core tools: `ripgrep`, `fd`, `fzf`, `tree`
- Network: `wget`, `mosh`, `openssh`
- Files: `unzip`, `zip`, `ffmpeg`
- Docs: `tldr`, `jless`

**NO → Continue to Step 3**

### Step 3: Is it platform-specific but not role-related?

**macOS-only** → `home/clord/packages/darwin.nix`
**Linux-only** → `home/clord/packages/linux.nix`

### Step 4: Still unsure?

Default to role-based modules. It's better to have it conditionally available via roles than globally installed on all systems.

## Role System

Roles are defined in `roles/default.nix` and configured per-host in `flake.nix`:

```nix
roles = {
  terminal.enable = true;          # Basic CLI tools
  development.enable = true;        # Development environment
  development.languages = {         # Language-specific tools
    go = true;
    rust = true;
    node = true;
    python = true;
    zig = false;
  };
  kubernetes.enable = true;         # K8s ecosystem
  grafana.enable = true;            # Grafana dev tools
  server.enable = false;            # Server management
  desktop.enable = true;            # GUI applications (Linux only)
};
```

## Examples

### ✅ Good: Adding a new Go tool

```nix
# In home/clord/modules/development.nix
(lib.mkIf (roles.development.enable && roles.development.languages.go) {
  home.packages = with pkgs; [
    go
    gopls
    air  # ← Add new Go tool here
  ];
})
```

### ✅ Good: Adding a universal utility

```nix
# In home/clord/packages/common.nix
home.packages = with pkgs; [
  ripgrep
  fd
  bat  # ← New universal tool
];
```

### ❌ Bad: Duplicating packages

```nix
# DON'T: Adding kubectl to packages/darwin.nix when it's already in modules/kubernetes.nix
# DON'T: Adding python to packages/common.nix when it's in modules/development.nix
```

### ✅ Good: Host-specific SSH config

```nix
# Create home/clord/ssh-configs/hostname.nix
{...}: {
  programs.ssh.extraConfig = ''
    Host myserver
      HostName server.example.com
      User admin
  '';
}

# Then import in home/clord/hostname.nix
imports = [
  ./ssh-configs/darwin-base.nix
  ./ssh-configs/hostname.nix
];
```

## Benefits of This System

1. **No Duplication**: Packages are defined once in the appropriate module
2. **Role-Based**: Systems only get packages they need based on their role
3. **Easy to Audit**: Clear separation makes it obvious where packages come from
4. **Maintainable**: Adding/removing features is as simple as toggling roles
5. **Consistent**: Same approach works for NixOS and macOS via nix-darwin

## Migration Summary

Recent improvements (2024-10):

1. ✅ Removed all duplicates from `packages/darwin.nix` (k8s tools → kubernetes module)
2. ✅ Removed duplicates from `packages/common.nix` (dev tools → development module)
3. ✅ Moved specialized tools to role modules (nixfmt, rbenv, bundix, sysbench)
4. ✅ Consolidated SSH configs into modular `ssh-configs/` directory
5. ✅ Simplified `waba.nix` and `edmon.nix` to just import appropriate configs

## Quick Reference

| Package Type | Location | Example |
|-------------|----------|---------|
| Universal CLI | `packages/common.nix` | `ripgrep`, `fzf`, `wget` |
| macOS-only utility | `packages/darwin.nix` | macOS-specific tools |
| Linux-only utility | `packages/linux.nix` | Linux-specific tools |
| Development tool | `modules/development.nix` | `git`, `nixd`, `sqlite` |
| Go/Rust/Node/Python | `modules/development.nix` | Language-specific sections |
| Kubernetes | `modules/kubernetes.nix` | `kubectl`, `helm`, `k9s` |
| Grafana | `modules/grafana.nix` | `jsonnet`, `tanka`, `k6` |
| Server tools | `modules/server.nix` | `docker`, monitoring tools |

## Checking for Duplicates

```bash
# Find all home.packages definitions
rg "home\.packages" home/clord/

# Compare package lists
diff <(rg -o '\b[a-z][a-z0-9-]+\b' home/clord/packages/common.nix | sort -u) \
     <(rg -o '\b[a-z][a-z0-9-]+\b' home/clord/modules/development.nix | sort -u)
```

## Future Improvements

- [ ] Audit remaining packages in `packages/common.nix` (basex, hledger, resvg, etc.)
- [ ] Create `desktop` role module for GUI applications
- [ ] Add `terminal.minimal` vs `terminal.full` distinction
- [ ] Document per-module package lists in module README files
