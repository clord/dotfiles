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
    overlays = with inputs; [rust-overlay.overlays.default];
    defaultModules = [
      inputs.agenix.nixosModules.default
      ./nixos-modules
      ./roles
    ];
    hm = {config, ...}: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          inherit (config) roles;
        };
      };
    };
    devShells = flake-utils.lib.eachDefaultSystemMap (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
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
    darwinConfigurations = {
      edmon = nix-darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
          inherit (inputs.devenv.packages.${system}) devenv;
          agenix = inputs.agenix.packages.${system}.default;
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        };
        modules =
          [
            home-manager.darwinModules.home-manager
            hm
            {roles.terminal.enable = true;}
            {
              home-manager.users.clord =
                import ./home/clord/edmon.nix
                // {
                  programs.ssh = {
                    enable = true;
                    extraConfig = ''
                      # Set up our host-specific stuff
                      # IdentityAgent /Users/clord/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
                      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
                    '';
                  };
                };
              clord.user = {
                enable = true;
                home = "/Users/clord";
              };
              users.users.clord.home = "/Users/clord";
            }
            ./systems/edmon.nix
          ]
          ++ defaultModules;
      };
    };

    nixosConfigurations = {
      wildwood = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit (inputs.devenv.packages.${system}) devenv;
          agenix = inputs.agenix.packages.${system}.default;
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        };
        modules =
          [
            nixos-hardware.nixosModules.system76
            home-manager.nixosModules.home-manager
            hm
            {roles.terminal.enable = true;}
            {
              clord.user = {
                extraGroups = ["wheel" "networkmanager"];
                enable = true;
                linuxUser = true;
              };
              home-manager.users.clord = import ./home/clord/default.nix;
            }
            {
              eugene.user = {
                enable = true;
                linuxUser = true;
                extraGroups = ["networkmanager"];
              };
              home-manager.users.eugene = import ./home/eugene/default.nix;
            }
            ./systems/wildwood.nix
            ./systems/common.nix
          ]
          ++ defaultModules;
      };

      dunbar = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          inherit (inputs.devenv.packages.${system}) devenv;
          agenix = inputs.agenix.packages.${system}.default;
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        };
        modules =
          [
            home-manager.nixosModules.home-manager
            hm
            {roles.terminal.enable = true;}
            {
              home-manager.users.clord = import ./home/clord/default.nix;
              clord.user = {
                extraGroups = ["wheel"];
                enable = true;
                linuxUser = true;
              };
            }
            ./systems/dunbar.nix
            ./systems/common.nix
          ]
          ++ defaultModules;
      };

      chickenpi = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          inherit (inputs.devenv.packages.${system}) devenv;
          agenix = inputs.agenix.packages.${system}.default;
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        };

        modules =
          [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {sdImage.compressImage = false;}
            {inherit (restedpi.packages.aarch64-linux) restedpi;}
            home-manager.nixosModules.home-manager
            hm
            {roles.terminal.enable = true;}
            {
              home-manager.users.clord = import ./home/clord/minimal.nix;
              clord.user = {
                extraGroups = ["wheel"];
                enable = true;
                linuxUser = true;
              };
            }
            ./systems/chickenpi.nix
            ./systems/common.nix
          ]
          ++ defaultModules;
      };
    };

    packages.aarch64-linux.chickenpiImage = self.nixosConfigurations.chickenpi.config.system.build.sdImage;
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    agenix.url = "github:ryantm/agenix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:rycee/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    restedpi.url = "github:clord/restedpi";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake = {
      url = "github:notashelf/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
