require "packer".startup(
  function(use)
    use "wbthomason/packer.nvim"

    -- Github Copilot
    use "github/copilot.vim"

    -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

   -- Visualize lsp progress
    use({
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup()
      end
    })

    use "neovim/nvim-lspconfig"

    -- batteries included rust tools
    use 'simrat39/rust-tools.nvim'

    use "nvim-treesitter/playground" -- treesitter debugging
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use('jose-elias-alvarez/null-ls.nvim')
    use('MunifTanjim/prettier.nvim')

    use {
      "cshuaimin/ssr.nvim",
      module = "ssr",
      -- Calling setup is optional.
      config = function()
        require("ssr").setup {
          min_width = 50,
          min_height = 5,
          keymaps = {
            close = "q",
            next_match = "n",
            prev_match = "N",
            replace_all = "<leader><cr>",
          },
        }
      end
    }

  -- Adds extra functionality over rust analyzer
  use("simrat39/rust-tools.nvim")

    -- Completion
    use({"L3MON4D3/LuaSnip", tag = "v1.1.0"})
    use {
      'hrsh7th/nvim-cmp',
      config = function ()
        require'cmp'.setup {
        snippet = {
          expand = function(args)
            require'luasnip'.lsp_expand(args.body)
          end
        },

        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp_document_symbol' },
          { name = 'path' },
          { name = 'buffer' },
        },
      }
      end
    }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help' } 
    use { 'hrsh7th/cmp-nvim-lsp-document-symbol' }

    use { 'saadparwaiz1/cmp_luasnip' }

    -- crs (coerce to snake_case)
    --- MixedCase (crm)
    --- camelCase (crc)
    --- snake_case (crs)
    --- UPPER_CASE (cru)
    --- dash-case (cr-)
    --- dot.case (cr.)
    --- space case (cr<space>)
    --- and Title Case (crt)
    use 'tpope/vim-abolish'

    -- Align stuff. select, <enter><space>. cycle with <enter>
    use 'junegunn/vim-easy-align'

    -- jump to certain spots
    use 'phaazon/hop.nvim'

    -- Try to automatically delete swap
    use 'gioele/vim-autoswap'

    -- > sa{motion}{addition} to add surround. e.g., saiw( changes foo to (foo)
    -- > sd{deletion} to remove surround, e.g., sd( changes (foo) to foo
    -- > sr{deletion}{addition} to replace surround, e.g., sr(" makes (foo) to "foo"
    -- You can count multiple surrounds, e.g., 4saiw({"+ makes foo +"{(foo)}"+
    -- You can repeat with .
    -- There are special magics:
    --  - fF: function: arg -> func(arg): saiwf -> foo to func(foo), sdf func(foo) -> foo
    --  - iI: instant: text -> {text}
    --  - tT: html tag: text -> <tag>text</tag>
    --        supports selectors for more expansion!
    --        saiwt div.foo#bar ->  <div class="foo" id="bar">foo</div>
    --
    -- Also provides new text objects!
    -- > is( is the inside of a pair of braces
    -- > iss is bound below to do automatic matching
    use 'machakann/vim-sandwich'

    -- Color
    use "norcalli/nvim-colorizer.lua"
    use "rktjmp/lush.nvim"
    -- use "sainnhe/sonokai"
    -- use "sainnhe/edge"
    -- use "sainnhe/everforest"
    -- use "sainnhe/gruvbox-material"
    -- use "kyazdani42/nvim-palenight.lua"
    -- use "folke/tokyonight.nvim"
    -- use "tjdevries/colorbuddy.vim"
    -- use "tjdevries/gruvbuddy.nvim"
    -- use "Th3Whit3Wolf/spacebuddy"
    -- use "Luxed/ayu-vim"
    -- use "connorholyday/vim-snazzy"
    -- use "fratajczak/one-monokai-vim"
    -- use "crusoexia/vim-monokai"
    -- use "rakr/vim-one"
    -- use "joshdick/onedark.vim"
    -- use { "olimorris/onedark.nvim", requires = "rktjmp/lush.nvim" }
    -- use { "alaric/nortia.nvim", requires = "rktjmp/lush.nvim" }
    -- use "junegunn/seoul256.vim"
    -- use "mhartington/oceanic-next"
    -- use "saltdotac/citylights.vim"

    use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    -- Edit
    use "tpope/vim-commentary"

    -- Movement
    use "tpope/vim-sleuth"


    -- UI
    use "nvim-lualine/lualine.nvim"
    use "akinsho/nvim-toggleterm.lua"

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}
    }
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

    -- Files
    use "justinmk/vim-gtfo"
    use "tpope/vim-eunuch"
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
          'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function() require'nvim-tree'.setup {} end
    }
    use "yamatsum/nvim-nonicons"

    -- Git
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },

      config = function()
        require('gitsigns').setup {
          current_line_blame = true,
          current_line_blame_opts = {
            virt_text = true,
            delay = 700
          },
        }
      end
    }
    use "lambdalisue/gina.vim"

    -- Lang
    use 'jparise/vim-graphql'

    -- Emmet expansion style. type a css selector any press CTRL-Y
    use 'mattn/emmet-vim'

    -- Misc
    use "wincent/terminus"
    use "marcushwz/nvim-workbench"
    use "milisims/nvim-luaref"
  end
)
