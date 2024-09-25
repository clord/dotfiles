{
  pkgs,
  roles,
  lib,
  ...
}: {
  config = lib.mkIf roles.terminal.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = "tokyonight";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };
        keys = {
          normal = {
            "esc" = ["collapse_selection" "keep_primary_selection"];
          };
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            scope = "source.nix";
            file-types = ["nix"];
            language-servers = ["nil"];
            auto-format = true;
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
              args = ["--quiet"];
            };
          }
          {
            name = "typescript";
            language-servers = ["typescript-language-server" "eslint"];
            formatter = {
              command = "${pkgs.nodePackages_latest.prettier}/bin/prettier";
              args = ["--parser" "typescript"];
              autoFormat = true;
            };
          }
          {
            name = "tsx";
            language-servers = ["typescript-language-server" "eslint"];
            formatter = {
              command = "${pkgs.nodePackages_latest.prettier}/bin/prettier";
              autoFormat = true;
              args = ["--parser" "typescript"];
            };
          }
        ];
        language-server = {
          gopls = {
            command = "${pkgs.gopls}/bin/gopls";
            args = ["serve"];
          };
          nil = {
            command = "${pkgs.nil}/bin/nil";
          };
          jsonnet-language-server = {
            command = "${pkgs.jsonnet-language-server}/bin/jsonnet-language-server";
            args = ["-t" "--lint"];
          };
          lua-language-server = {
            command = "${pkgs.lua-language-server}/bin/lua-language-server";
          };
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            args = [];
            config = {
              check = {
                command = "clippy";
                features = "all";
              };
              diagnostics = {experimental = {enable = true;};};
              hover = {actions = {enable = true;};};
              typing = {autoClosingAngleBrackets = {enable = true;};};
              cargo = {allFeatures = true;};
              procMacro = {enable = true;};
            };
          };

          eslint = with pkgs.nodePackages_latest; {
            command = "${eslint}/bin/eslint";
            args = ["--stdin"];
            config = {
              codeActionsOnSave = {
                mode = "all";
                "source.fixAll.eslint" = true;
              };
              format = {enable = true;};
              nodePath = "${pkgs.nodejs_22}";
              quiet = false;
              run = "onType";
              validate = "on";
              codeAction = {
              };
            };
          };

          typescript-language-server = with pkgs.nodePackages_latest; {
            command = "${typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio"];
          };
        };
      };
    };
  };
}
