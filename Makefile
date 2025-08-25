# NixOS commands
nixos-switch:
	sudo nixos-rebuild switch --flake .

nixos-check:
	nixos-rebuild dry-build --flake .

nixos-build:
	nixos-rebuild build --flake .

# Darwin/macOS commands
darwin-switch: 
	nix run nix-darwin -- switch --flake .

darwin-check:
	@echo "🔍 Checking Darwin configuration..."
	nix run nix-darwin -- check --flake .

darwin-build:
	@echo "🔨 Building Darwin configuration..."
	nix build .#darwinConfigurations.$$(hostname -s).system

# Utility commands
rekey:
	cd secrets; nix run "github:ryantm/agenix" -- -r

fmt:
	nix fmt

check:
	nix flake check

update:
	nix flake update

# Remote deployments
deploy-chickenpi:
	nixos-rebuild switch --flake .#chickenpi --target-host root@10.68.3.17

# Help target
help:
	@echo "Available targets:"
	@echo "  Darwin/macOS:"
	@echo "    darwin-switch  - Apply Darwin configuration"
	@echo "    darwin-check   - Check Darwin configuration"
	@echo "    darwin-build   - Build Darwin configuration"
	@echo ""
	@echo "  NixOS:"
	@echo "    nixos-switch   - Apply NixOS configuration"
	@echo "    nixos-check    - Dry-run NixOS configuration"
	@echo "    nixos-build    - Build NixOS configuration"
	@echo ""
	@echo "  Development:"
	@echo "    fmt            - Format all Nix files"
	@echo "    check          - Run flake checks"
	@echo "    update         - Update flake inputs"
	@echo "    rekey          - Re-encrypt secrets"
	@echo ""
	@echo "  Remote:"
	@echo "    deploy-chickenpi - Deploy to chickenpi"

.PHONY: nixos-switch nixos-check nixos-build darwin-switch darwin-check darwin-build rekey fmt check update deploy-chickenpi help

