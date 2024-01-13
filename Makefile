switch:
	sudo nixos-rebuild switch --flake .

clord-linux-minimal:
	nix build '.#homeManagerConfigurations.clord-linux-minimal.activationPackage'

