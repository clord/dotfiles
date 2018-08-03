call plug#begin('~/.vim/plugged')

" Show a nice startup screen
Plug 'mhinz/vim-startify'

" Colors
"Plug 'junegunn/seoul256.vim'
"Plug 'bruschill/madeofcode'
"Plug 'NLKNguyen/papercolor-theme'
"Plug 'erezsh/erezvim'
"Plug 'fcpg/vim-farout'
Plug 'ajmwagar/vim-deus'

" Try to automatically delete swap
Plug 'gioele/vim-autoswap'

" Align stuff. select, <enter><space>. cycle with <enter>
Plug 'junegunn/vim-easy-align'

" jump to certain spots with leader-leader-w
Plug 'Lokaltog/vim-easymotion'

Plug 'hauleth/sad.vim'

" Ruby text objects (car to change a ruby block)
"Plug 'rhysd/vim-textobj-ruby'

" Git wrapper (git-from-vim)
Plug 'tpope/vim-fugitive'

" surround: s motion: cs
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" cml to comment out line, cmip to comment block
Plug 'tpope/vim-commentary'

" cmake support for invoking build etc
Plug 'vhdirk/vim-cmake'

" Really awesome way to quickly spit out boilerplate.
" Plug 'sirver/ultisnips'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" Decent typescript ide features for deoplete
Plug 'mhartington/nvim-typescript'
Plug 'tasn/vim-tsx'

" accounting
Plug 'ledger/vim-ledger'

" Fancy patched font stuff
" Plug 'ryanoasis/vim-devicons'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" [count]["x]gr{motion} -> replace motion with register x
"Plug 'vim-scripts/ReplaceWithRegister'

" Syntax checking
" Plug 'vim-syntastic/syntastic'

" Haskell-specific project features (`cabal install hdevtools`)
" Plug 'bitc/vim-hdevtools'

" Hard to live without git change markers
"Plug 'airblade/vim-gitgutter'

" Lots of ruby goodness
"Plug 'vim-ruby/vim-ruby'

" User defined textobjs, typically required by other plugins
Plug 'kana/vim-textobj-user'

" Haskell color and indentation
Plug 'neovimhaskell/haskell-vim'

" Silver Search. :Ag to find things in cwd
Plug 'rking/ag.vim'

" Just some nice things for JS
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Adds :FixWhitespace
Plug 'bronson/vim-trailing-whitespace'

" fzf.vim is a fuzzy finder (brew install fzf)
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'


" Control-p is a fuzzy finder
" Plug 'ctrlpvim/ctrlp.vim'

" Move through camelCase words with <leader><motion>
Plug 'bkad/CamelCaseMotion'

" Rust language support
Plug 'rust-lang/rust.vim'

" Control-n to select current word and put a virtual cursor. keep hitting.
"Plug 'terryma/vim-multiple-cursors'

call plug#end()

call camelcasemotion#CreateMotionMappings('<leader>')

let g:deoplete#enable_at_startup = 1

syntax enable
filetype plugin indent on

" Yup.
set encoding=utf-8

" Disable modelines since i dont use them and they can do crazy things
set modelines=0

" Yea it works for me
set autoindent

" Like seeing '-- INSERT --' at the bottom
"set showmode

" mostly for explaining things to people
"set showcmd

" hide files when opening another
set hidden

" No 'beep' when the kids are asleep
set visualbell

" Smooth scrolling with multiple panes on tty
set ttyfast
set lazyredraw

" Line and col info on cmdline info bar
set ruler

"
set backspace=indent,eol,start

" Line numbers in gutter are relative to current location (great for motions)
set relativenumber
set number " Will show the absolute number!

"
set cpoptions+=J

" Which shell to use
set shell=/bin/zsh

" Match parens, and wait for some tenths of seconds
set showmatch
set matchtime=3

" Split windows below
set splitbelow " set splitright

"
set fillchars=diff:⣿

" Leader {{{
let mapleader = ","
let maplocalleader = "\\"
" }}}

"
set ttimeout
set notimeout
set nottimeout

" Round to the indent col
set shiftround

" Re-read a file if it is open and not changed in vim, but changed outside
set autoread

" Set the window title to file
set title

" Spelling
set dictionary=/usr/share/dict/words

set foldlevelstart=99

" ControlP
"let g:ctrlp_map = '<c-p>'
"let g:ctrlp_working_path_mode = 'ra'
"nmap <leader>p :CtrlP<cr>
"nmap <leader>b :CtrlPBuffer<cr>
"nmap <leader>t :CtrlPTag<cr>


nmap <c-p> :GFiles<cr>
xmap <c-p> :GFiles<cr>
omap <c-p> :GFiles<cr>
nmap <leader>p <plug>(fzf-maps-n)
xmap <leader>p <plug>(fzf-maps-x)
omap <leader>p <plug>(fzf-maps-o)
nnoremap <leader>d :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>


" Wildmenu completion {{{
set wildmenu
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.u,*.d                          " make dependency files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.jsbundle                       " JS Bundle from react-native
set wildignore+=node_modules,.bundle             " locally installed packages
" }}}

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Save when losing focus
"au FocusLost * :wa

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="



" Tabs, spaces, wrapping {{{
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nowrap
set textwidth=110
set formatoptions=qrn1
" }}}

" Unified color scheme 
colorscheme deus

if has("gui_vimr")
set termguicolors
endif

" Backups, Undo {{{
set undodir=~/tmp/undo/     " undo files
set backupdir=~/tmp/backup/ " backups
set directory=~/tmp/swap/   " swap files
set backup                       " enable backups

"
set history=1000

"
set undofile

"
set undoreload=10000
" }}}


" Status line ------------------------------------------------------------- {{{

" Always show statusline
set laststatus=2

set background=dark
" highlight Normal guibg=black guifg=white

let g:airline_theme = 'molokai'

let g:airline_powerline_fonts = 1

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Open a new buffer
map <F1> :enew<CR>

map <F2> :bprevious<CR>
map <F3> :bnext<CR>

" Close the current buffer and move to the previous one
map <F4> :bp <BAR> bd #<CR>




" }}}

" }}}
" Searching and movement -------------------------------------------------- {{{

set ignorecase
set smartcase
set incsearch
set hlsearch
set gdefault

"set scrolloff=3
"set sidescroll=1
"set sidescrolloff=10

set virtualedit+=block

noremap <leader><space> :noh<cr>:call clearmatches()<cr>

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" Ack for the last search.
nnoremap <silent> <leader>? :execute "Ag '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" ag can be installed in /usr/local/bin
let $PATH .= ':/usr/local/bin'

" We make q a special macro register, which we can replay via shortcut
nnoremap <leader><bs> @q

" Also allow backsapce in visual mode to replay macro q
vnoremap <silent> <bs> :norm @q<cr>

" Haskell Stuff
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1


" Directional Keys {{{

" It's the future
"noremap j gj
"noremap k gk

" Easy buffer navigation
noremap <leader>v <C-w>v

" }}}



" }}}
" Folding ----------------------------------------------------------------- {{{



" }}}

" Various filetype-specific stuff ----------------------------------------- {{{

" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=syntax
augroup END

" }}}

" Javascript {{{

let g:jsx_ext_required = 0

augroup ft_javascript
    au!

    au FileType javascript setlocal foldmethod=marker
    au FileType javascript setlocal foldmarker={,}
augroup END

" }}}
" Lisp {{{

augroup ft_lisp
    au!
    au FileType lisp call TurnOnLispFolding()
augroup END

" }}}
" Markdown {{{

augroup ft_markdown
    au!

    au BufNewFile,BufRead *.m*down setlocal filetype=markdown

    " Use <localleader>1/2/3 to add headings.
    au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=
    au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-
    au Filetype markdown nnoremap <buffer> <localleader>3 I### <ESC>
augroup END

" }}}
" Nginx {{{

augroup ft_nginx
    au!

    au BufRead,BufNewFile /etc/nginx/conf/*                      set ft=nginx
    au BufRead,BufNewFile /etc/nginx/sites-available/*           set ft=nginx
    au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
    au BufRead,BufNewFile vhost.nginx                            set ft=nginx

    au FileType nginx setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}
" Ruby {{{


augroup ft_ruby
    au!
    au Filetype ruby setlocal foldmethod=marker
augroup END

" }}}
" Vim {{{

augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}


" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>



" }}}


" Convenience mappings ---------------------------------------------------- {{{

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Less chording
nnoremap ; :

set completeopt=longest,menuone,preview

" Sudo to write
" cmap w!! w !sudo tee % >/dev/null
cmap w!! w !sudo tee > /dev/null %

" Toggle paste
" set pastetoggle=<F8>

" --- type & to search the word in all files in the current dir
nmap & :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Ag

" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>
" gaip=<enter> to easyalign a vim paragraph
nmap ga <Plug>(EasyAlign)

" Startify
let g:startify_list_order = [
      \ ['   Sessions '],  'sessions',
      \ ['   MRU '],       'files' ,
      \ ['   MRU DIR '],   'dir',
      \ ['   Bookmarks '], 'bookmarks',
      \ ]

let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ 'bundle/.*/doc',
      \ ]

let g:startify_bookmarks              = [ {'v': '~/.vimrc'} ]
let g:startify_change_to_dir          = 0
let g:startify_enable_special         = 0
let g:startify_files_number           = 8
let g:startify_session_autoload       = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence    = 1

function! s:center_header(lines) abort
  let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
  let centered_lines = map(copy(a:lines), 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction

let g:startify_session_dir = "~/.vim/sessions"
let g:startify_custom_header = s:center_header(split("Hello", '\n'))


let g:cmake_install_prefix = "/usr/local"
let g:cmake_cxx_compiler = "clang++"
let g:cmake_c_compiler= "clang"

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Environments (GUI/Console) ---------------------------------------------- {{{

if has('gui_running')
    "set guifont=Hack:h12 "" https://github.com/chrissimpkins/Hack
    "set guifont=Iosevka:h15
    "set guifont=Fira Code:h15

    " Remove all the UI cruft
    set go-=T
    set go-=l
    set go-=L
    set go-=r
    set go-=R

    highlight SpellBad term=underline gui=undercurl guisp=Orange

    " Use a line-drawing char for pretty vertical splits.
    set fillchars+=vert:╏ "❚

    " Different cursors for different modes.
    set guicursor=n-c:block-Cursor-blinkon0
    set guicursor+=v:block-vCursor-blinkon0
    highlight Cursor guifg=white guibg=black
    highlight iCursor guifg=white guibg=green

    if has("gui_macvim")
        " Full screen means FULL screen
        set fuoptions=maxvert,maxhorz

        " Use the normal HIG movements, except for M-Up/Down
        let macvim_skip_cmd_opt_movement = 1
        no   <D-Left>       <Home>
        no!  <D-Left>       <Home>
        no   <M-Left>       <C-Left>
        no!  <M-Left>       <C-Left>

        no   <D-Right>      <End>
        no!  <D-Right>      <End>
        no   <M-Right>      <C-Right>
        no!  <M-Right>      <C-Right>

        no   <D-Up>         <C-Home>
        ino  <D-Up>         <C-Home>
        imap <M-Up>         <C-o>{

        no   <D-Down>       <C-End>
        ino  <D-Down>       <C-End>
        imap <M-Down>       <C-o>}

        imap <M-BS>         <C-w>
        inoremap <D-BS>     <esc>my0c`y
    else
        " Non-MacVim GUI, like Gvim
    end
else
    " Console Vim
endif


" Window split settings
highlight TermCursor ctermfg=red guifg=red
set splitbelow
set splitright

" Terminal settings
tnoremap <Leader><ESC> <C-\><C-n>
" Window navigation function
" Make ctrl-h/j/k/l move between windows and auto-insert in terminals
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["h", "j", "l", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor

source ~/tmp/user.vim

