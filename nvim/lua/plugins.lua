require "packer".startup(
  function(use)
    use "wbthomason/packer.nvim"

       -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    use "nvim-treesitter/playground" -- treesitter debugging

    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- Completion
    use "hrsh7th/nvim-cmp"

    -- crs (coerce to snake_case)
    -- MixedCase (crm)
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

    use 'jparise/vim-graphql'

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

    -- Edit
    use "tpope/vim-surround"
    use "Raimondi/delimitMate"
    use "tpope/vim-commentary"

    -- Movement
    use "justinmk/vim-sneak"
    use "tpope/vim-sleuth"

    -- UI
    use "hoob3rt/lualine.nvim"
    use "akinsho/nvim-toggleterm.lua"

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}
    }
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

    -- Files
    use "justinmk/vim-dirvish"
    use "justinmk/vim-gtfo"
    use "tpope/vim-eunuch"
    use "kyazdani42/nvim-tree.lua"
    use "kyazdani42/nvim-web-devicons"
    use "yamatsum/nvim-nonicons"

    -- Git
    use {"lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim"}
    use "lambdalisue/gina.vim"
    use "kdheepak/lazygit.nvim"

    -- Snippets
    use {"hrsh7th/vim-vsnip", requires = "kitagry/vs-snippets"}

    -- Lang
    use "lervag/vimtex"
    use "petRUShka/vim-gap"
    use "petRUShka/vim-magma"
    use "westeri/asl-vim" -- ACPI
    use "tikhomirov/vim-glsl"

    -- Emmet expansion style. type a css selector any press CTRL-Y
    use 'mattn/emmet-vim'
    use "pest-parser/pest.vim"
    use "jwalton512/vim-blade"
    use "pantharshit00/vim-prisma"

    -- Misc
    use "wincent/terminus"
    use "marcushwz/nvim-workbench"
    use "milisims/nvim-luaref"
    use "jbyuki/nabla.nvim"

    -- Experimenting
    use "tpope/vim-unimpaired"
  end
)
