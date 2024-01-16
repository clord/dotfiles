{
  description = "NixOS configuration for all machines in the network";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    agenix.url = "github:ryantm/agenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    restedpi.url = "github:clord/restedpi";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nix-darwin, home-manager, restedpi, nixpkgs
    , nixos-hardware, agenix }: {

      darwinConfigurations.edmon = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          agenix.nixosModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord-edmon.nix; 
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          ./systems/edmon.nix
        ];
      };
      nixosConfigurations.wildwood = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.system76
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord-minimal.nix;
          }
          ./systems/wildwood.nix
          ./systems/common.nix
        ];
      };

      nixosConfigurations.dunbar = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord.nix;
          }
          ./systems/dunbar.nix
          ./systems/common.nix
        ];
      };

      nixosConfigurations.chickenpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          agenix.nixosModules.default
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          { sdImage.compressImage = false; }
          { restedpi = restedpi.packages.aarch64-linux.restedpi; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord-minimal.nix;
          }
          ./systems/chickenpi.nix
          ./systems/common.nix
        ];
      };

      packages.aarch64-linux.chickenpiImage =
        self.nixosConfigurations.chickenpi.config.system.build.sdImage;
    };

}
