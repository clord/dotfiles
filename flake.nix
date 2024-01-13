{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, home-manager, nixpkgs, nixos-hardware, sops-nix, unstable }: {
    package = {
      # TODO: Build a chickenpi image?
      # chickenpiImage =
      #  self.nixosConfigurations.chickenpi.config.system.build.sdImage;
    };

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
        nixos-hardware.nixosModules.raspberry-pi-4
        sops-nix.nixosModules.sops
        {
          sops.defaultSopsFile = ./secrets/dunbar.yaml;
        }
        ./systems/dunbar.nix
        ./systems/common.nix
      ];
    };

    nixosConfigurations.chickenpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
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
}
