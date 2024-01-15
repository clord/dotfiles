{
  description = "NixOS configuration for all machines in the network";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    restedpi.url = "github:clord/restedpi";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nix-darwin, home-manager, restedpi, nixpkgs, nixos-hardware, sops-nix  }: {

      darwinConfigurations.edmon = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
         modules = [
           sops-nix.nixosModules.sops
           { sops.defaultSopsFile = ./secrets/edmon.yaml; }
           home-manager.nixosModules.home-manager
	    {
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.users.clord = import ./home/clord-edmon.nix;
	    }
            ./systems/edmon.nix
           ];
             
      };

	nixosConfigurations.wildwood = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
 	  modules = [
            nixos-hardware.nixosModules.system76
	    sops-nix.nixosModules.sops
            { sops.defaultSopsFile = ./secrets/wildwood.yaml; }
	    home-manager.nixosModules.home-manager
	    {
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.users.clord = import ./home/clord-minimal.nix;
	    }
            ./systems/wildwood.nix
            ./systems/common.nix
            ./systems/user.nix
	  ];
	};	

        nixosConfigurations.dunbar = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            sops-nix.nixosModules.sops
            { sops.defaultSopsFile = ./secrets/dunbar.yaml; }
            home-manager.nixosModules.home-manager
            {
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.users.clord = import ./home/clord.nix;
            }
            ./systems/dunbar.nix
            ./systems/common.nix
            ./systems/user.nix
          ];
        };

        nixosConfigurations.chickenpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";

          modules = [
            #  nixos-hardware.nixosModules.raspberry-pi-4
            sops-nix.nixosModules.sops
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            { sdImage.compressImage = false; }
            { sops.defaultSopsFile = ./secrets/chickenpi.yaml;  }
            { restedpi = restedpi.packages.aarch64-linux.restedpi; }
            home-manager.nixosModules.home-manager
            {
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.users.clord = import ./home/clord-minimal.nix;
            }
            {
              sops.defaultSopsFile = ./secrets/chickenpi.yaml;
              sops.secrets.application_secret = { };
              sops.secrets.configuration = { };
              sops.secrets.rip_cert = { };
              sops.secrets.rip_key = { };
            }
            ./systems/chickenpi.nix
            ./systems/common.nix
            ./systems/user.nix
          ];
        };

        packages.aarch64-linux.chickenpiImage = self.nixosConfigurations.chickenpi.config.system.build.sdImage;
      };

}
