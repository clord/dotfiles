#   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆
#    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦
#          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄
#           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄
#          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀
#   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄
#  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄
# ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄
# ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄
#      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆
#       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃
{
  description = "NixOS configuration for all machines in the network";
  outputs = {
    self,
    home-manager,
    restedpi,
    nixpkgs,
    nix-darwin,
    nixos-hardware,
    flake-utils,
    ...
  } @ inputs: let
    commonModules = [
      inputs.agenix.nixosModules.default
      ./nixos-modules
      ./roles
    ];
    linuxCommonModules = [
      ./systems/common.nix
    ];
    homeManagerConfig = {config, ...}: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          inherit (config) roles;
        };
      };
    };

    createPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = with inputs; [
          rust-overlay.overlays.default
          devenv.overlays.default
        ];
        config.allowUnfree = true;
      };

    createSpecialArgs = system: {
      inherit inputs;
      agenix = inputs.agenix.packages.${system}.default;
      pkgs = createPkgs system;
    };

    # Helper function for user configuration
    mkUserConfig = {
      username,
      config,
      homeConfig ? null,
    }: let
      userAttrs = {
        "${username}".user = config;
      };
      homeAttrs =
        if homeConfig != null
        then {home-manager.users.${username} = homeConfig;}
        else {};
    in
      userAttrs // homeAttrs;

    # Base modules for all systems
    baseModules = system: isLinux:
      [
        (
          if isLinux
          then home-manager.nixosModules.home-manager
          else home-manager.darwinModules.home-manager
        )
        homeManagerConfig
        {roles.terminal.enable = true;}
      ]
      ++ commonModules
      ++ (
        if isLinux
        then linuxCommonModules
        else []
      );

    # These are tools that are used to develop dotfiles themselves
    devShells = flake-utils.lib.eachDefaultSystemMap (
      system: let
        pkgs = createPkgs system;
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixd
            nil
            statix
            alejandra
            deadnix
          ];
        };
      }
    );
  in {
    inherit devShells;

    # Formatter for nix fmt
    formatter = flake-utils.lib.eachDefaultSystemMap (
      system: (createPkgs system).alejandra
    );

    # Checks for CI/validation
    checks = flake-utils.lib.eachDefaultSystemMap (
      system: let
        pkgs = createPkgs system;
      in {
        format =
          pkgs.runCommand "check-format" {
            buildInputs = with pkgs; [alejandra];
          } ''
            ${pkgs.alejandra}/bin/alejandra --check ${./.}
            touch $out
          '';

        statix =
          pkgs.runCommand "check-statix" {
            buildInputs = with pkgs; [statix];
          } ''
            ${pkgs.statix}/bin/statix check ${./.}
            touch $out
          '';

        deadnix =
          pkgs.runCommand "check-deadnix" {
            buildInputs = with pkgs; [deadnix];
          } ''
            ${pkgs.deadnix}/bin/deadnix --fail ${./.}
            touch $out
          '';
      }
    );

    darwinConfigurations = {
      waba = let
        system = "aarch64-darwin";
      in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = createSpecialArgs system;
          modules =
            baseModules system false
            ++ [
              (mkUserConfig {
                username = "clord";
                config = {
                  enable = true;
                  home = "/Users/clord";
                };
                homeConfig = import ./home/clord/waba.nix;
              })
              {users.users.clord.home = "/Users/clord";}
              ./systems/waba.nix
            ];
        };
      edmon = let
        system = "aarch64-darwin";
      in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = createSpecialArgs system;
          modules =
            baseModules system false
            ++ [
              (mkUserConfig {
                username = "clord";
                config = {
                  enable = true;
                  home = "/Users/clord";
                };
                homeConfig = import ./home/clord/edmon.nix;
              })
              {users.users.clord.home = "/Users/clord";}
              ./systems/edmon.nix
            ];
        };
    };

    nixosConfigurations = {
      wildwood = let
        system = "x86_64-linux";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = createSpecialArgs system;
          modules =
            baseModules system true
            ++ [
              nixos-hardware.nixosModules.system76
              (mkUserConfig {
                username = "clord";
                config = {
                  extraGroups = [
                    "wheel"
                    "networkmanager"
                  ];
                  isLinux = true;
                  enable = true;
                };
                homeConfig = import ./home/clord/default.nix;
              })
              (mkUserConfig {
                username = "eugene";
                config = {
                  enable = true;
                  isLinux = true;
                  extraGroups = ["networkmanager"];
                };
                homeConfig = import ./home/eugene/default.nix;
              })
              ./systems/wildwood.nix
            ];
        };

      dunbar = let
        system = "aarch64-linux";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = createSpecialArgs system;
          modules =
            baseModules system true
            ++ [
              (mkUserConfig {
                username = "clord";
                config = {
                  extraGroups = ["wheel"];
                  isLinux = true;
                  enable = true;
                };
                homeConfig = import ./home/clord/default.nix;
              })
              ./systems/dunbar.nix
            ];
        };

      chickenpi = let
        system = "aarch64-linux";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = createSpecialArgs system;
          modules =
            baseModules system true
            ++ [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              {sdImage.compressImage = false;}
              {inherit (restedpi.packages.${system}) restedpi;}
              (mkUserConfig {
                username = "clord";
                config = {
                  extraGroups = ["wheel"];
                  isLinux = true;
                  enable = true;
                };
                homeConfig = import ./home/clord/minimal.nix;
              })
              ./systems/chickenpi.nix
            ];
        };
    };

    packages.aarch64-linux.chickenpiImage =
      self.nixosConfigurations.chickenpi.config.system.build.sdImage;
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    agenix.url = "github:ryantm/agenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    devenv = {
      url = "github:cachix/devenv/v1.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    restedpi.url = "github:clord/restedpi";
    neovim-flake = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
