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
  outputs =
    {
      self,
      home-manager,
      restedpi,
      nixpkgs,
      nix-darwin,
      nixos-hardware,
      flake-utils,
      ...
    }@inputs:
    let
      commonModules = [
        inputs.agenix.nixosModules.default
        ./roles
      ];
      linuxCommonModules = [
        ./nixos-modules  # Contains platform-aware modules
        ./systems/common.nix
      ];
      darwinCommonModules = [
        ./nixos-modules  # Contains platform-aware modules (will filter internally)
      ];
      homeManagerConfig =
        { config, ... }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              inherit (config) roles;
            };
          };
        };

      createPkgs =
        system:
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
      mkUserConfig =
        {
          username,
          config ? {},
          homeConfig ? null,
          isLinux ? false,
        }:
        let
          userAttrs = if isLinux && config != {} then {
            users.users.${username} = config;
          } else {};
          homeAttrs = if homeConfig != null then { home-manager.users.${username} = homeConfig; } else { };
        in
        userAttrs // homeAttrs;

      # Base modules for all systems
      baseModules =
        system: isLinux:
        [
          (
            if isLinux then home-manager.nixosModules.home-manager else home-manager.darwinModules.home-manager
          )
          homeManagerConfig
          { roles.terminal.enable = true; }
        ]
        ++ commonModules
        ++ (if isLinux then linuxCommonModules else darwinCommonModules);

      # These are tools that are used to develop dotfiles themselves
      devShells = flake-utils.lib.eachDefaultSystemMap (
        system:
        let
          pkgs = createPkgs system;
        in
        {
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
    in
    {
      inherit devShells;

      # Formatter for nix fmt
      formatter = flake-utils.lib.eachDefaultSystemMap (system: (createPkgs system).alejandra);

      # Checks for CI/validation
      checks = flake-utils.lib.eachDefaultSystemMap (
        system:
        let
          pkgs = createPkgs system;
        in
        {
          format =
            pkgs.runCommand "check-format"
              {
                buildInputs = with pkgs; [ alejandra ];
              }
              ''
                ${pkgs.alejandra}/bin/alejandra --check ${./.}
                touch $out
              '';

          statix =
            pkgs.runCommand "check-statix"
              {
                buildInputs = with pkgs; [ statix ];
              }
              ''
                ${pkgs.statix}/bin/statix check ${./.}
                touch $out
              '';

          deadnix =
            pkgs.runCommand "check-deadnix"
              {
                buildInputs = with pkgs; [ deadnix ];
              }
              ''
                ${pkgs.deadnix}/bin/deadnix --fail ${./.}
                touch $out
              '';
        }
      );

      darwinConfigurations = {
        waba =
          let
            system = "aarch64-darwin";
          in
          nix-darwin.lib.darwinSystem {
            inherit system;
            specialArgs = createSpecialArgs system;
            modules = baseModules system false ++ [
              {
                # Set roles for waba (work machine)
                roles = {
                  terminal.enable = true;
                  development = {
                    enable = true;
                    languages = {
                      go = true;
                      rust = true;
                      node = true;
                      python = true;
                      zig = true;
                    };
                  };
                  kubernetes = {
                    enable = true;
                    includeHelm = true;
                    includeK9s = true;
                  };
                  grafana = {
                    enable = true;
                    includeCloud = true;
                  };
                  server.enable = true; # Need server tools for development
                };
              }
              (mkUserConfig {
                username = "clord";
                homeConfig = import ./home/clord/waba.nix;
              })
              { users.users.clord.home = "/Users/clord"; }
              ./systems/waba.nix
            ];
          };
        edmon =
          let
            system = "aarch64-darwin";
          in
          nix-darwin.lib.darwinSystem {
            inherit system;
            specialArgs = createSpecialArgs system;
            modules = baseModules system false ++ [
              {
                # Set roles for edmon (personal machine)
                roles = {
                  terminal.enable = true;
                  development = {
                    enable = true;
                    languages = {
                      go = true;
                      rust = true;
                      node = true;
                      python = true;
                    };
                  };
                  kubernetes = {
                    enable = false; # Personal machine, less k8s
                    includeHelm = false;
                    includeK9s = false;
                  };
                  grafana = {
                    enable = false; # No Grafana on personal
                    includeCloud = false;
                  };
                };
              }
              (mkUserConfig {
                username = "clord";
                homeConfig = import ./home/clord/edmon.nix;
              })
              { users.users.clord.home = "/Users/clord"; }
              ./systems/edmon.nix
            ];
          };
      };

      nixosConfigurations = {
        wildwood =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = createSpecialArgs system;
            modules = baseModules system true ++ [
              nixos-hardware.nixosModules.system76
              {
                # Set roles for wildwood (desktop workstation)
                roles = {
                  terminal.enable = true;
                  development = {
                    enable = true;
                    languages = {
                      go = true;
                      rust = true;
                      node = true;
                      python = true;
                    };
                  };
                  kubernetes = {
                    enable = true;
                    includeHelm = true;
                    includeK9s = true;
                  };
                  grafana = {
                    enable = false;
                    includeCloud = false;
                  };
                  desktop = {
                    enable = true; # Has GNOME
                    gaming = false;
                    multimedia = false;
                  };
                };
              }
              (mkUserConfig {
                username = "clord";
                isLinux = true;
                config = {
                  extraGroups = [
                    "wheel"
                    "networkmanager"
                  ];
                };
                homeConfig = import ./home/clord/default.nix;
              })
              (mkUserConfig {
                username = "eugene";
                isLinux = true;
                config = {
                  extraGroups = [ "networkmanager" ];
                };
                homeConfig = import ./home/eugene/default.nix;
              })
              ./systems/wildwood.nix
            ];
          };

        dunbar =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = createSpecialArgs system;
            modules = baseModules system true ++ [
              {
                # Set roles for dunbar (headless server)
                roles = {
                  terminal.enable = true;
                  development = {
                    enable = true;
                    languages = {
                      go = true;
                      rust = false;
                      node = false;
                      python = true;
                      zig = false;
                    };
                  };
                  kubernetes = {
                    enable = false; # Server, no k8s
                    includeHelm = false;
                    includeK9s = false;
                  };
                  grafana = {
                    enable = false;
                    includeCloud = false;
                  };
                  desktop = {
                    enable = false; # Headless
                    gaming = false;
                    multimedia = false;
                  };
                  server.enable = true;
                };
              }
              (mkUserConfig {
                username = "clord";
                isLinux = true;
                config = {
                  extraGroups = [ "wheel" ];
                };
                homeConfig = import ./home/clord/default.nix;
              })
              ./systems/dunbar.nix
            ];
          };

        chickenpi =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = createSpecialArgs system;
            modules = baseModules system true ++ [
              "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
              { sdImage.compressImage = false; }
              { inherit (restedpi.packages.${system}) restedpi; }
              {
                # Set minimal roles for chickenpi (Raspberry Pi)
                roles = {
                  terminal.enable = true; # Basic terminal only
                  development = {
                    enable = false; # Minimal system
                    languages = {
                      go = false;
                      rust = false;
                      node = false;
                      python = false;
                    };
                  };
                  kubernetes = {
                    enable = false;
                    includeHelm = false;
                    includeK9s = false;
                  };
                  grafana = {
                    enable = false;
                    includeCloud = false;
                  };
                  desktop = {
                    enable = false;
                    gaming = false;
                    multimedia = false;
                  };
                };
              }
              (mkUserConfig {
                username = "clord";
                isLinux = true;
                config = {
                  extraGroups = [ "wheel" ];
                };
                homeConfig = import ./home/clord/minimal.nix;
              })
              ./systems/chickenpi.nix
            ];
          };
      };

      packages.aarch64-linux.chickenpiImage =
        self.nixosConfigurations.chickenpi.config.system.build.sdImage;

      # Export public keys for agenix
      publicKeys = import ./pubkeys/default.nix;
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
