{
  home-manager,
  nixpkgs,
  stateVersion,
  agenix,
  inputs,
}: let
  inherit (nixpkgs) lib;
  commonModules = [agenix.nixosModules.agenix ../nixos-modules ../roles];

  mkHomeConfiguration = user:
    home-manager.lib.homeManagerConfiguration {
      modules = commonModules ++ [(import ../home/${user})];
      extraSpecialArgs = {
        inherit stateVersion lib;
        isStandalone = true;
      };
    };

  mkNixosConfiguration = system: host: cfg:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        commonModules
        ++ [(import ./machines/${host})]
        ++ [
          home-manager.nixosModules.home-manager
          (_: {
            system = {inherit stateVersion;};
            nix.settings.experimental-features = ["flakes" "nix-command"];
            home-manager = {
              useUserPackages = false;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                inherit inputs stateVersion lib;
                inherit (cfg) roles;
              };
              users = map (user: (lib.attrsets.nameValuePair user (import ./home/${user}))) cfg.admins;
            };
          })
        ];
      specialArgs = {
        inherit inputs stateVersion lib;
        agenix = agenix.packages.${system}.default;
        isStandalone = false;
      };
    };

  mkDarwinConfiguration = system: host: cfg @ {
    admins,
    roles,
    users,
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules =
        commonModules
        ++ [(import ./machines/${host})]
        ++ [
          home-manager.nixosModules.home-manager
          (_: {
            system.stateVersion = stateVersion;
            nix.settings.experimental-features = ["flakes" "nix-command"];
            home-manager = {
              useUserPackages = false;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                inherit inputs stateVersion lib;
                inherit (cfg) roles;
              };
              users = map (user: (lib.attrsets.nameValuePair user (import ./home/${user}))) admins;
            };
          })
        ];
      specialArgs = {
        inherit inputs stateVersion lib;
        agenix = agenix.packages.${system}.default;
        isStandalone = false;
      };
    };
in {
  mkNixOSConfigurations =
    lib.attrsets.mapAttrs'
    (host: cfg @ {
      os,
      cpu,
      ...
    }: (lib.attrsets.nameValuePair host (mkNixosConfiguration "${cpu}-${os}" host cfg)));

  mkDarwinConfigurations =
    lib.attrsets.mapAttrs'
    (host: cfg @ {
      os,
      cpu,
      ...
    }: (lib.attrsets.nameValuePair host (mkDarwinConfiguration "${cpu}-${os}" host cfg)));

  mkHomeConfigurations = list:
    builtins.listToAttrs (map (username: (lib.attrsets.nameValuePair username (mkHomeConfiguration username))) list);
}
