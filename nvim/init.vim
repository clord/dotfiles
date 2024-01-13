scriptencoding utf-8

call plug#begin(stdpath('data') . '/plugged')
Plug 'LnL7/vim-nix'
Plug 'ayu-theme/ayu-vim'
Plug 'google/vim-jsonnet'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/vim-easy-align'
call plug#end()

lua require'plugins'

set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu
syntax enable

" Font
set guifont=MonoLisa\ Nerd\ Font\ Mono:h16
set tabstop=2
set shiftwidth=0 " 0 => use same value as tabstop
set expandtab
set smartindent
filetype plugin indent on

set listchars=trail:·,nbsp:_,tab:\ \ 
set encoding=utf-8
set list
set shortmess+=tIc
set showcmd
set noshowmode
set lazyredraw
set ignorecase
set smartcase
set autoread
set signcolumn=yes
set diffopt+=iwhite
set scrolloff=5
set undofile
set completeopt=menuone,noselect
set updatetime=300
set clipboard=unnamedplus
set spelllang=en_ca,en_us

set hidden

nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

let mapleader = ","
let maplocalleader = ","

let g:tex_flavor='latex'
let g:tex_conceal='abdmg'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

augroup auto_filetypes
  autocmd!
  " LaTeX
  " autocmd Filetype tex set conceallevel=1
  autocmd BufRead,BufNewFile *.cls set filetype=tex
  autocmd Filetype tex setlocal spell

  " nvim-tree
  autocmd Filetype NvimTree setlocal cursorline
augroup END


function! s:tabterm(...) abort
  if a:0 == 0
    tabedit term://$SHELL
  else
    execute "tabedit term://" . a:1
  endif
endfunction
command! -nargs=? -complete=shellcmd Tabterm call <SID>tabterm(<f-args>) " eg `:tabterm yarn dev` will open a new tab and run `yarn dev`

function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction


source ~/.config/nvim/neovide.vim
source ~/.config/nvim/plugin-settings.vim
lua require'plugin-settings'
lua require'init'


