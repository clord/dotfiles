nixos-switch:
	sudo nixos-rebuild switch --flake .

rekey:
	cd secrets; nix run "github:ryantm/agenix" -- -r

darwin-switch: 
	nix run nix-darwin -- switch --flake .

deploy-chickenpi:
	nixos-rebuild switch --flake .#chickenpi --target-host root@10.68.3.17

