{
  description = "NixOS configuration for all machines in the network";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix.url = "github:Mic92/sops-nix";
    systems.url = "github:nix-systems/default";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    restedpi.url = "github:clord/restedpi";
  };
  outputs = inputs@{ self, flake-parts, home-manager, restedpi, nixpkgs
    , nixos-hardware, sops-nix, systems, unstable }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = (import systems);
      flake = { 
        homeManagerConfigurations = {
          "clord@linux" = home-manager.lib.homeManagerConfiguration {
            configuration = ./home/common.nix;
            homeDirectory = "/home/clord";
            username = "clord";
            extraModules = [ sops-nix.homeManagerModules.sops ];
          };
        };

        nixosConfigurations.dunbar = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            sops-nix.nixosModules.sops
            { sops.defaultSopsFile = ./secrets/dunbar.yaml; }
            ./systems/dunbar.nix
            ./systems/common.nix
          ];
        };

        nixosConfigurations.chickenpi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            sops-nix.nixosModules.sops
            {
              sops.defaultSopsFile = ./secrets/chickenpi.yaml;
              sops.secrets.application_secret = { };
              sops.secrets.rip_cert = { };
              sops.secrets.rip_key = { };
            }
            ./systems/chickenpi.nix
            ./systems/common.nix
          ];
        };
      };
    };
}
