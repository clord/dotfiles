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
  pkgs,
  ...
}: {
  # based on https://github.com/NotAShelf/neovim-flake
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
            spellcheck = {
              enable = false;
            };
            debugMode = {
              enable = false;
              level = 20;
              logFile = "/tmp/nvim.log";
            };

            dashboard = {
              startify = {
                enable = true;
                changeToVCRoot = true;
                customHeader = [
                  "                                                                      "
                  "         ████ ██████           █████      ██                    "
                  "        ███████████             █████                            "
                  "        █████████ ███████████████████ ███   ███████████  "
                  "       █████████  ███    █████████████ █████ ██████████████  "
                  "      █████████ ██████████ █████████ █████ █████ ████ █████  "
                  "    ███████████ ███    ███ █████████ █████ █████ ████ █████ "
                  "   ██████  █████████████████████ ████ █████ █████ ████ ██████"
                ];
              };
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
                  rename = "<leader>r";
                  renderHoveredDoc = "K";
                  nextDiagnostic = "]d";
                  previousDiagnostic = "[d";
                  codeAction = "<leader>a";
                  signatureHelp = "<leader>gh";
                  smartScrollUp = "<C-u>";
                  smartScrollDown = "<C-d>";
                };
              };
              lspkind.enable = true;
              lightbulb.enable = false;
            };

            telescope = {
              enable = true;
              setupOpts = {
                vimgrep_arguments = [
                  "${pkgs.ripgrep}/bin/rg"
                  "--color=never"
                  "--no-heading"
                  "--with-filename"
                  "--line-number"
                  "--column"
                  "--smart-case"
                ];
              };
              mappings = {
                findFiles = "<C-p>";
                liveGrep = "<C-f>";
                gitCommits = "<leader>hcc";
                gitBufferCommits = "<leader>hcb";
                gitBranches = "<leader>hvr";
                gitStatus = "<leader>hvs";
                gitStash = "<leader>hvx";
              };
            };
            utility = {
              ccc.enable = true;
              vim-wakatime.enable = false;
              icon-picker.enable = false;
              surround = {
                enable = true;
                useVendoredKeybindings = true;
              };
              diffview-nvim.enable = true;
              motion = {
                # hop.enable = true;
                leap.enable = true;
              };
            };

            treesitter = {
              enable = true;
              fold = true;
              autotagHtml = true;
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
              go.enable = true;
              python.enable = true;
            };

            visuals = {
              enable = true;
              nvimWebDevicons.enable = true;
              highlight-undo.enable = true;
              cellularAutomaton = {
                enable = true;
              };
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
                lineTimeout = 500;
              };
            };

            statusline = {
              lualine = {
                enable = true;
              };
            };

            tabline = {
              nvimBufferline = {
                enable = true;
              };
            };

            autopairs.enable = false;

            autocomplete = {
              enable = true;
              type = "nvim-cmp";
              mappings = {
                next = "<Down>";
                previous = "<Up>";
              };
            };

            filetree = {
              nvimTree = {
                enable = true;
                mappings = {
                  toggle = "<leader>e";
                  findFile = "<leader>eg";
                  focus = "<leader>ef";
                  refresh = "<leader>er";
                };
                setupOpts = {
                  view.float = {enable = true;};
                  openOnSetup = false;
                };
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
            };

            terminal = {
              toggleterm = {
                enable = true;
                setupOpts = {
                  direction = "float";
                  enable_winbar = true;
                };
              };
            };

            ui = {
              borders.enable = false;
              noice.enable = true;
              colorizer.enable = true;
              modes-nvim.enable = true;
              breadcrumbs = {
                enable = true;
                navbuddy.enable = true;
              };
            };

            assistant = {
              copilot = {
                enable = true;
                cmp.enable = true;
                mappings = {
                  panel = {
                    refresh = "<leader>cr";
                    open = "<leader>co";
                  };
                };
              };
            };

            session = {
              nvim-session-manager.enable = false;
            };

            gestures = {
              gesture-nvim.enable = false;
            };

            comments = {
              comment-nvim = {
                enable = true;
                mappings = {
                  toggleCurrentLine = "<C-c>";
                };
              };
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
