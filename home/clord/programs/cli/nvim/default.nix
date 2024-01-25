{
  inputs,
  roles,
  lib,
  ...
}: {
  imports = [inputs.neovim-flake.homeManagerModules.default];
  config = lib.mkIf roles.terminal.enable {
    programs.neovim-flake = {
      enable = true;
      # your settings need to go into the settings attribute set
      # most settings are documented in the appendix
      settings = {
        config = {
          vim = {
            leaderKey = ",";
            lineNumberMode = "number";
            viAlias = true;
            vimAlias = true;
            debugMode = {
              enable = false;
              level = 20;
              logFile = "/tmp/nvim.log";
            };
          };

          vim.lsp = {
            formatOnSave = true;
            lspkind.enable = false;
            lightbulb.enable = true;
            lspsaga.enable = false;
            nvimCodeActionMenu.enable = true;
            trouble.enable = true;
            lspSignature.enable = true;
            #lsplines.enable = isMaximal;
            #nvim-docs-view.enable = isMaximal;
          };

          vim.debugger = {
            nvim-dap = {
              enable = true;
              ui.enable = true;
            };
          };

          vim.languages = {
            enableLSP = true;
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            nix.enable = true;
            html.enable = true;
            clang = {
              enable = true;
              lsp.server = "clangd";
            };
            sql.enable = true;
            rust = {
              enable = true;
              crates.enable = true;
            };
            ts.enable = true;
            go.enable = true;
            python.enable = true;
            bash.enable = true;
          };

          vim.visuals = {
            enable = true;
            nvimWebDevicons.enable = true;
            fidget-nvim.enable = true;
            highlight-undo.enable = true;

            indentBlankline = {
              enable = true;
              fillChar = null;
              eolChar = null;
              scope = {
                enabled = true;
              };
            };

            cursorline = {
              enable = true;
              lineTimeout = 0;
            };
          };

          vim.statusline = {
            lualine = {
              enable = true;
              theme = "tokyonight";
            };
          };

          vim.theme = {
            enable = true;
            name = "tokyonight";
            style = "night";
            transparent = false;
          };
          vim.autopairs.enable = true;

          vim.autocomplete = {
            enable = true;
            type = "nvim-cmp";
          };

          vim.filetree = {
            nvimTree = {
              enable = true;
            };
          };

          vim.tabline = {
            nvimBufferline.enable = true;
          };

          vim.treesitter.context.enable = true;

          vim.binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          vim.telescope.enable = true;

          vim.git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions = false; # throws an annoying debug message
          };

          vim.minimap = {
            minimap-vim.enable = false;
            codewindow.enable = true; # lighter, faster, and uses lua for configuration
          };

          vim.dashboard = {
            dashboard-nvim.enable = false;
            alpha.enable = true;
          };

          vim.notify = {
            nvim-notify.enable = true;
          };

          vim.projects = {
            project-nvim.enable = false;
          };

          vim.utility = {
            ccc.enable = true;
            vim-wakatime.enable = false;
            icon-picker.enable = false;
            surround.enable = true;
            diffview-nvim.enable = true;
            motion = {
              hop.enable = true;
              leap.enable = true;
            };
          };

          vim.notes = {
            orgmode.enable = false;
            mind-nvim.enable = false;
            todo-comments.enable = true;
          };

          vim.terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
            };
          };

          vim.ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            modes-nvim.enable = false; # the theme looks terrible with catppuccin
            illuminate.enable = true;
            breadcrumbs = {
              enable = true;
              navbuddy.enable = true;
            };
            smartcolumn = {
              enable = true;
              columnAt.languages = {
                # this is a freeform module, it's `buftype = int;` for configuring column position
                nix = 110;
                ruby = 120;
                java = 130;
                go = [90 130];
              };
            };
          };

          vim.assistant = {
            copilot = {
              enable = true;
              cmp.enable = true;
            };
          };

          vim.session = {
            nvim-session-manager.enable = false;
          };

          vim.gestures = {
            gesture-nvim.enable = false;
          };

          vim.comments = {
            comment-nvim.enable = true;
          };

          vim.presence = {
            neocord.enable = false;
          };
        };
      };
    };
  };
}
