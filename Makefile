switch:
	sudo nixos-rebuild switch --flake .

deploy:
	nixos-rebuild switch --flake .#chickenpi --target-host root@10.68.3.170

