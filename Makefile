switch:
	sudo nixos-rebuild switch --flake .

clordAtChickenpi:
	nix build '.#homeConfigurations.clord@chickenpi.activationPackage'

