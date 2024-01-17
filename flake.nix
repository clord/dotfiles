{
  description = "NixOS configuration for all machines in the network";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    agenix.url = "github:ryantm/agenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    restedpi.url = "github:clord/restedpi";
    #nix-darwin.url = "github:LnL7/nix-darwin";
    #nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self,  home-manager, restedpi, nixpkgs, nixos-hardware, agenix }@inputs:
    let defaultModules = [ agenix.nixosModules.default ./nixos-modules/default.nix ];
    in {
      #darwinConfigurations.edmon = nix-darwin.lib.darwinSystem {
      #  system = "aarch64-darwin";
      #  specialArgs = { inherit inputs; agenix = inputs.agenix.packages.aarch64-darwin.default; };
      #  modules = [
      #    home-manager.darwinModules.home-manager
      #    {
      #      home-manager.useGlobalPkgs = true;
      #      home-manager.useUserPackages = true;
      #      home-manager.users.clord = import ./home/clord-edmon.nix;
      #      home-manager.extraSpecialArgs = { inherit inputs; };
       #   }
      #    ./systems/edmon.nix
      #  ] ++ defaultModules;
      #};
      nixosConfigurations.wildwood = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; agenix = inputs.agenix.packages.x86_64-linux.default; };
        modules = [
          nixos-hardware.nixosModules.system76
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord-minimal.nix;
            clord.user.enable = true;
          }
          ./systems/wildwood.nix
          ./systems/common.nix
        ] ++ defaultModules;
      };

      nixosConfigurations.dunbar = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; agenix = inputs.agenix.packages.aarch64-linux.default; };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord.nix;
            clord.user.enable = true;
          }
          ./systems/dunbar.nix
          ./systems/common.nix
        ] ++ defaultModules;
      };

      nixosConfigurations.chickenpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; agenix = inputs.agenix.packages.aarch64-linux.default; };

        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          { sdImage.compressImage = false; }
          { restedpi = restedpi.packages.aarch64-linux.restedpi; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.clord = import ./home/clord-minimal.nix;
            clord.user.enable = true;
          }
          ./systems/chickenpi.nix
          ./systems/common.nix
        ] ++ defaultModules;
      };

      packages.aarch64-linux.chickenpiImage = self.nixosConfigurations.chickenpi.config.system.build.sdImage;
    };

}
