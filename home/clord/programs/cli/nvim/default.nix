#                                                               
#                       ████ ██████           █████      ██
#                      ███████████             █████ 
#                      █████████ ███████████████████ ███   ███████████
#                     █████████  ███    █████████████ █████ ██████████████
#                    █████████ ██████████ █████████ █████ █████ ████ █████
#                  ███████████ ███    ███ █████████ █████ █████ ████ █████
#                 ██████  █████████████████████ ████ █████ █████ ████ ██████
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
      settings = {
        config = {
          vim = {
            leaderKey = ",";
            lineNumberMode = "number";
            viAlias = true;
            vimAlias = true;
            tabWidth = 2;
            useSystemClipboard = true;
            spellChecking = {
              enable = true;
              # enableProgrammingWordList = true;
            };
            debugMode = {
              enable = false;
              level = 20;
              logFile = "/tmp/nvim.log";
            };

            lsp = {
              formatOnSave = true;
              mappings = {
                goToType = "gt";
                goToDefinition = "gd";
                listImplementations = "gi";
                listReferences = "gR";
              };
              trouble = {
                enable = true;
                mappings = {
                  workspaceDiagnostics = "<leader>gD";
                  documentDiagnostics = "<leader>gd";
                  lspReferences = "<leader>gr";
                };
              };
              lspsaga = {
                enable = true;
                mappings = {
                  rename = "gr";
                  renderHoveredDoc = "K";
                  nextDiagnostic = "]d";
                  previousDiagnostic = "[d";
                  codeAction = "ga";
                  signatureHelp = "gh";
                  smartScrollUp = "<C-u>";
                  smartScrollDown = "<C-d>";
                };
              };
              lspkind.enable = true;
              lightbulb.enable = false;
            };

            telescope = {
              enable = true;
              mappings = {
                findFiles = "<C-p>";
                liveGrep = "<C-f>";
              };
            };
            utility = {
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

            languages = {
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
              rust = {
                enable = true;
                crates.enable = true;
              };
              ts.enable = true;
              go.enable = true;
              python.enable = true;
              bash.enable = true;
            };

            visuals = {
              enable = true;
              nvimWebDevicons.enable = true;
              fidget-nvim.enable = true;
              indentBlankline = {
                enable = true;
                fillChar = null;
                eolChar = null;
                scope = {
                  enabled = false;
                };
              };
              cursorline = {
                enable = true;
                lineTimeout = 200;
              };
            };

            statusline = {
              lualine = {
                enable = true;
                theme = "tokyonight";
              };
            };

            theme = {
              enable = true;
              name = "tokyonight";
              style = "night";
              transparent = false;
            };
            autopairs.enable = false;

            autocomplete = {
              enable = true;
              type = "nvim-cmp";
            };

            filetree = {
              nvimTree = {
                enable = true;
                mappings = {toggle = "<leader>e";};
                view.float = {enable = true;};
                openOnSetup = false;
              };
            };

            binds = {
              whichKey.enable = true;
              cheatsheet.enable = true;
            };

            git = {
              enable = true;
              gitsigns = {
                enable = true;
                mappings = {
                  # hunks
                  nextHunk = "]c";
                  previousHunk = "[c";
                  stageHunk = "<leader>hs";
                  undoStageHunk = "<leader>hu";
                  resetHunk = "<leader>hr";
                  previewHunk = "<leader>hP";
                  # buffers
                  stageBuffer = "<leader>hS";
                  resetBuffer = "<leader>hR";
                  blameLine = "<leader>hb";
                  toggleBlame = "<leader>tb";
                  diffThis = "<leader>hd";
                  diffProject = "<leader>hD";
                  toggleDeleted = "<leader>td";
                };
              };
            };

            notify = {
              nvim-notify.enable = true;
            };

            projects = {
              project-nvim.enable = false;
            };

            notes = {
              orgmode.enable = false;
              mind-nvim.enable = false;
              todo-comments.enable = true;
            };

            terminal = {
              toggleterm = {
                enable = true;
              };
            };

            ui = {
              borders.enable = false;
              noice.enable = true;
              colorizer.enable = true;
              modes-nvim.enable = true;
              illuminate.enable = true;
              breadcrumbs = {
                enable = true;
                navbuddy.enable = true;
              };
            };

            assistant = {
              copilot = {
                enable = true;
                cmp.enable = true;
                mappings.panel.refresh = "<leader>cr";
              };
            };

            session = {
              nvim-session-manager.enable = false;
            };

            gestures = {
              gesture-nvim.enable = false;
            };

            comments = {
              comment-nvim.enable = false;
            };

            presence = {
              neocord.enable = false;
            };
          };
        };
      };
    };
  };
}
