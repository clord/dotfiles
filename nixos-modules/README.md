# NixOS Modules

This directory contains NixOS-specific system modules. These modules **only work on NixOS/Linux systems** and will not function on Darwin/macOS.

## Available Modules

### Core Modules

#### `agenix.nix`
- **Purpose**: Secret management with age encryption
- **Platform**: NixOS and Darwin (special case)
- **Usage**: Automatically imported, configures secret decryption
- **Configuration**: Define secrets in `secrets/secrets.nix`

### NixOS-Only Modules

These modules use NixOS-specific options and are only imported on Linux systems:

#### `networking.nix`
- **Purpose**: Common networking configuration
- **Platform**: NixOS only
- **Options**:
  - `modules.networking.enable`: Enable the module
  - `modules.networking.hostName`: System hostname
  - `modules.networking.enableNetworkManager`: Use NetworkManager
  - `modules.networking.allowedTCPPorts`: Open TCP ports
  - `modules.networking.enableIPv6`: IPv6 support
- **Includes**: Network tools, mDNS, DNS configuration

#### `security.nix`
- **Purpose**: Security hardening settings
- **Platform**: NixOS only
- **Options**:
  - `modules.security.enable`: Enable security hardening
  - `modules.security.enableSudo`: Configure sudo
  - `modules.security.sshConfig.*`: SSH server settings
  - `modules.security.enableAppArmor`: AppArmor support
- **Includes**: SSH hardening, PAM configuration, audit rules

#### `services.nix`
- **Purpose**: Common service configurations
- **Platform**: NixOS only
- **Options**:
  - `modules.services.enableDocker`: Docker containerization
  - `modules.services.enablePodman`: Rootless containers
  - `modules.services.enableTailscale`: Tailscale VPN
  - `modules.services.enableSyncthing`: File synchronization
- **Includes**: Container tools, virtualization, networking services

### `user/`
- **Purpose**: User account management
- **Platform**: NixOS only
- **Files**:
  - `clord.nix`: Primary user configuration
  - `eugene.nix`: Secondary user configuration
- **Usage**: Defines user accounts, groups, and permissions

## Usage

These modules are automatically imported for NixOS systems via `flake.nix`:

```nix
# Only included for Linux systems
linuxCommonModules = [
  ./systems/common.nix
];

# The nixos-modules are part of commonModules but conditional
```

To use a module in your NixOS system configuration:

```nix
{
  modules.networking = {
    enable = true;
    hostName = "myhost";
    allowedTCPPorts = [ 80 443 ];
  };
  
  modules.security = {
    enable = true;
    sshConfig.enable = true;
  };
}
```

## Platform Compatibility

| Module | NixOS | Darwin | Notes |
|--------|-------|--------|-------|
| agenix.nix | ✅ | ✅ | Works on both platforms |
| networking.nix | ✅ | ❌ | Uses NixOS networking options |
| security.nix | ✅ | ❌ | Uses NixOS security options |
| services.nix | ✅ | ❌ | Uses NixOS systemd services |
| user/*.nix | ✅ | ❌ | NixOS user management |

## Adding New Modules

1. Determine if the module is NixOS-specific
2. Create a new `.nix` file in this directory
3. Define options under `modules.<name>`
4. Add configuration in the `config` section
5. Import in `default.nix` with platform checks
6. Document the module here

## Best Practices

- Use `mkOption` with clear descriptions
- Provide sensible defaults
- Use `mkIf` for conditional configuration
- Keep modules focused on a single concern
- Document platform requirements
- Test on appropriate platforms only