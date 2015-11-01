call plug#begin('~/.vim/plugged')

" Colors
"Plug 'junegunn/seoul256.vim'
"Plug 'bruschill/madeofcode'
Plug 'NLKNguyen/papercolor-theme'
"Plug 'erezsh/erezvim'

" Align stuff. select, <enter><space>. cycle with <enter>
Plug 'junegunn/vim-easy-align'

" jump to certain spots with leader-leader-w
Plug 'Lokaltog/vim-easymotion'

" Ruby text objects (car to change a ruby block)
"Plug 'rhysd/vim-textobj-ruby'

" Git wrapper (git-from-vim)
Plug 'tpope/vim-fugitive'

" surround: s motion: cs
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" cml to comment out line, cmip to comment block
Plug 'tpope/vim-commentary'

" Really awesome way to quickly spit out boilerplate.
Plug 'garbas/vim-snipmate'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
" Plus some actual snippets
Plug 'honza/vim-snippets'

" Hard to live without git change markers
Plug 'airblade/vim-gitgutter'

Plug 'vim-ruby/vim-ruby'

" User defined textobjs, typically required by other plugins
Plug 'kana/vim-textobj-user'

" Silver Search. :Ag to find things in cwd
Plug 'rking/ag.vim'

" Just some nice things for JS
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Adds :FixWhitespace
Plug 'bronson/vim-trailing-whitespace'

" Control-p is a fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

" Move through camelCase words with <leader><motion>
Plug 'bkad/CamelCaseMotion'

" Control-n to select current word and put a virtual cursor. keep hitting.
"Plug 'terryma/vim-multiple-cursors'

call plug#end()

syntax enable
filetype plugin indent on

" Yup.
set encoding=utf-8

" Disable modelines since i dont use them and they can do crazy things
set modelines=0

" Yea it works for me
set autoindent

" Like seeing '-- INSERT --' at the bottom
set showmode

" mostly for explaining things to people
set showcmd

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

" Always show statusline
set laststatus=2

"
set cpoptions+=J

" Which shell to use
set shell=/bin/bash

" Don't redraw during macros etc
set lazyredraw

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
let g:ctrlp_working_path_mode = 'ra'
nmap <leader>p :CtrlP<cr>
nmap <leader>b :CtrlPBuffer<cr>
nmap <leader>t :CtrlPTag<cr>


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
set tabstop=3
set shiftwidth=3
set softtabstop=3
set expandtab
set nowrap
set textwidth=110
set formatoptions=qrn1
" }}}

" Unified color scheme (default: dark)
"colo seoul256
"colo erezvim

set background=light
colorscheme PaperColor

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

"augroup ft_statuslinecolor
"    au!
"    au InsertEnter * hi StatusLine ctermfg=196 guifg=#FF3145
"    au InsertLeave * hi StatusLine ctermfg=130 guifg=#CD5907
"augroup END

"set statusline=%f    " Path.
"set statusline+=%m   " Modified flag.
"set statusline+=%r   " Readonly flag.
"set statusline+=%w   " Preview window flag.

"set statusline+=\    " Space.

"set statusline+=%#redbar#                " Highlight the following as a warning.
"set statusline+=%{SyntasticStatuslineFlag()} " Syntastic errors.
"set statusline+=%*                           " Reset highlighting.

"set statusline+=%=   " Right align.

" File format, encoding and type.  Ex: "(unix/utf-8/python)"
"set statusline+=(
"set statusline+=%{&ff}                        " Format (unix/DOS).
"set statusline+=/
"set statusline+=%{strlen(&fenc)?&fenc:&enc}   " Encoding (utf-8).
"set statusline+=/
"set statusline+=%{&ft}                        " Type (python).
"set statusline+=)

" Line and column position and counts.
"set statusline+=\ (line\ %l\/%L,\ col\ %03c)

" }}}
" Abbreviations ----------------------------------------------------------- {{{
function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

function! MakeSpacelessIabbrev(from, to)
    execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction

call MakeSpacelessIabbrev('cl/',  'http://christopher.lord.ac/')
call MakeSpacelessIabbrev('gh/',  'http://github.com/clord/')
call MakeSpacelessIabbrev('fsc/', 'http://www.freshslowcooking.com/')

iabbrev cl@ christopher@lord.ac
iabbrev clp@ christopher@pliosoft.com
iabbrev clg@ christopherlord@gmail.com

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
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Directional Keys {{{

" It's the future
noremap j gj
noremap k gk

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>v <C-w>v

" }}}


" Visual Mode */# from Scrooloose {{{
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>
" }}}

" }}}
" Folding ----------------------------------------------------------------- {{{

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" Use ,z to "focus" the current fold.
nnoremap <leader>z zMzvzz


" }}}
" Various filetype-specific stuff ----------------------------------------- {{{

" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=syntax
augroup END

" }}}
" Javascript {{{

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
"
" }}}
" Quick editing ----------------------------------------------------------- {{{

nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>

" }}}
" Shell ------------------------------------------------------------------- {{{

function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell

" }}}
" Convenience mappings ---------------------------------------------------- {{{

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Less chording
nnoremap ; :

" Faster Esc
inoremap jk <esc>

set completeopt=longest,menuone,preview

" Sudo to write
" cmap w!! w !sudo tee % >/dev/null
cmap w!! w !sudo tee > /dev/null %

" Toggle paste
set pastetoggle=<F8>

" --- type & to search the word in all files in the current dir
nmap & :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>/ :Ag

" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>
" gaip=<enter> to easyalign a vim paragraph
nmap ga <Plug>(EasyAlign)


" Environments (GUI/Console) ---------------------------------------------- {{{

if has('gui_running')
    set guifont=Hack:h10 "" https://github.com/chrissimpkins/Hack

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
    "set guicursor+=i-ci:ver20-iCursor

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

source ~/tmp/user.vim

