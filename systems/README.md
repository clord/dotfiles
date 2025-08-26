# Systems

This directory contains system-specific configurations for each machine.

## System Configurations

### Darwin (macOS) Systems

#### `waba.nix`
- **Type**: MacBook Pro (M-series)
- **Purpose**: Work development machine
- **Roles**: Full development stack, Kubernetes, Grafana
- **Special**: 1Password SSH integration

#### `edmon.nix`
- **Type**: MacBook (M-series)
- **Purpose**: Personal development machine
- **Roles**: Development tools, personal projects

#### `darwin-common.nix`
- **Purpose**: Shared macOS system settings
- **Includes**:
  - System defaults (Dock, Finder, etc.)
  - Security settings
  - Trackpad and keyboard configuration
  - Common system packages

### NixOS (Linux) Systems

#### `wildwood.nix`
- **Type**: Desktop workstation (x86_64)
- **Hardware**: System76
- **Purpose**: Main Linux workstation
- **Features**:
  - GNOME desktop environment
  - LUKS encryption
  - Multi-user support (clord, eugene)

#### `dunbar.nix`
- **Type**: Server (aarch64)
- **Purpose**: Headless server
- **Features**: Service hosting, remote access

#### `chickenpi.nix`
- **Type**: Raspberry Pi (aarch64)
- **Purpose**: Home automation/services
- **Features**:
  - SD card image build
  - Minimal configuration
  - RestedPi integration

#### `common.nix`
- **Purpose**: Shared NixOS settings
- **Includes**: Common system configuration for all Linux systems

## Configuration Structure

Each system configuration typically includes:

1. **Hardware Configuration**
   - Boot settings
   - File systems
   - Hardware-specific modules

2. **Networking**
   - Hostname
   - Network manager settings
   - Firewall rules

3. **Services**
   - System services
   - User services
   - Scheduled tasks

4. **System Packages**
   - System-wide packages
   - Development tools
   - Administration utilities

## Adding a New System

1. Create `systems/<hostname>.nix`:
```nix
{ config, pkgs, ... }: {
  # Hardware configuration
  boot = { ... };
  
  # Networking
  networking.hostName = "hostname";
  
  # Services
  services = { ... };
  
  # Packages
  environment.systemPackages = [ ... ];
}
```

2. Add to `flake.nix`:
```nix
darwinConfigurations.hostname = ...
# or
nixosConfigurations.hostname = ...
```

3. Set appropriate roles in the flake
4. Create home configuration if needed
5. Document the system here

## Remote Deployment

For remote systems, add deployment commands to `Makefile`:

```make
deploy-hostname:
	nixos-rebuild switch --flake .#hostname --target-host user@ip
```

## Best Practices

- Keep hardware-specific settings in system files
- Use common files for shared configuration
- Document special hardware requirements
- Include role assignments in flake
- Test configurations before deployment