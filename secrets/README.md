# Secrets Management with agenix

This directory contains encrypted secrets managed by [agenix](https://github.com/ryantm/agenix), a age-based encryption tool for NixOS secrets.

## Overview

Agenix allows us to:
- Store encrypted secrets in the repository
- Decrypt them automatically at system activation
- Manage access control via SSH keys
- Rotate secrets safely

## Directory Structure

```
secrets/
├── README.md           # This file
├── secrets.nix         # Secret definitions and key assignments
├── *.age              # Encrypted secret files
└── .gitignore         # Ignore decrypted files
```

## Workflow

### Adding a New Secret

1. Create or update `secrets.nix` to define the secret:
```nix
{
  "mySecret.age" = {
    publicKeys = [ user1 host1 ];
  };
}
```

2. Edit the secret:
```bash
cd secrets
agenix -e mySecret.age
```

3. Reference in NixOS configuration:
```nix
age.secrets.mySecret.file = ../secrets/mySecret.age;
```

4. Use the decrypted path:
```nix
services.myservice.passwordFile = config.age.secrets.mySecret.path;
```

### Rekeying Secrets

When adding/removing users or hosts:
```bash
make rekey
# or manually:
cd secrets && agenix -r
```

### Adding a New User

1. Add their SSH public key to `pubkeys/<username>.pub`
2. Update `secrets.nix` to include their key
3. Rekey all secrets

### Adding a New Host

1. Get the host's SSH key:
```bash
ssh-keyscan hostname | grep ed25519 > pubkeys/hostname.pub
```

2. Update `secrets.nix` to include the host
3. Rekey all secrets

## Key Management

### User Keys
User SSH keys are stored in `../pubkeys/` directory:
- `clord.pub` - Primary user
- `eugene.pub` - Secondary user

### Host Keys
Host keys are also in `../pubkeys/`:
- System host keys for each NixOS system
- These are automatically used during system activation

## Security Best Practices

1. **Never commit decrypted secrets**
   - Always use `.age` extension
   - Check git diff before committing

2. **Principle of Least Privilege**
   - Only grant access to keys that need it
   - Use host-specific secrets when possible

3. **Regular Rotation**
   - Rotate secrets periodically
   - Update after removing user access
   - Change after potential compromise

4. **Backup Keys**
   - Keep secure backups of private keys
   - Store recovery keys separately
   - Document key ownership

## Common Commands

```bash
# Edit a secret
agenix -e secretname.age

# Rekey all secrets
agenix -r

# List who has access
agenix -l

# Decrypt manually (for debugging)
age -d -i ~/.ssh/id_ed25519 secretname.age
```

## Troubleshooting

### Secret not decrypting
- Check if your key is in the publicKeys list
- Verify the secret was rekeyed after adding your key
- Ensure SSH agent has your key loaded

### Permission denied
- Check file ownership after decryption
- Verify service user has read access
- Check systemd service User/Group settings

### Changes not taking effect
- Run `nixos-rebuild switch` or `darwin-rebuild switch`
- Check activation script output
- Verify secret path in configuration

## Current Secrets

| File | Description | Access |
|------|-------------|--------|
| `rootPasswd.age` | Root password hash | All hosts |
| `clordPasswd.age` | User password hash | User systems |
| `eugenePasswd.age` | User password hash | User systems |
| `chickenpi*.age` | Raspberry Pi specific | chickenpi only |

## Integration with Nix

The secrets are integrated via the `nixos-modules/agenix.nix` module, which:
- Configures age identities
- Sets up secret paths
- Manages permissions
- Handles activation