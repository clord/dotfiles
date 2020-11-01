let FZF_DEFAULT_COMMAND = "fd --type f --hidden  --follow --exclude .git --exclude node_modules "

call plug#begin('~/.vim/plugged')

" Show a nice startup screen
Plug 'mhinz/vim-startify'

" Themes
" Plug 'rakr/vim-one'
Plug 'morhetz/gruvbox'
" Plug 'altercation/vim-colors-solarized'

Plug 'elixir-editors/vim-elixir'
Plug 'jparise/vim-graphql'

" Try to automatically delete swap
Plug 'gioele/vim-autoswap'

" Align stuff. select, <enter><space>. cycle with <enter>
Plug 'junegunn/vim-easy-align'

" jump to certain spots with leader-leader-w
Plug 'Lokaltog/vim-easymotion'

Plug 'hauleth/sad.vim'

" :JsonPath to echo path at cursor, :JsonPath a.b.c to jump to a.b.c
Plug 'mogelbrod/vim-jsonpath'

" Decent typescript stuff
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Git wrapper (git-from-vim)
Plug 'tpope/vim-fugitive'

" Emmet expansion style. type a css selector any press CTRL-Y
Plug 'mattn/emmet-vim'

" > sa{motion}{addition} to add surround. e.g., saiw( changes foo to (foo)
" > sd{deletion} to remove surround, e.g., sd( changes (foo) to foo
" > sr{deletion}{addition} to replace surround, e.g., sr(" makes (foo) to "foo"
" You can count multiple surrounds, e.g., 4saiw({"+ makes foo +"{(foo)}"+
" You can repeat with .
" There are special magics:
"  - fF: function: arg -> func(arg): saiwf -> foo to func(foo), sdf func(foo) -> foo
"  - iI: instant: text -> {text}
"  - tT: html tag: text -> <tag>text</tag>
"        supports selectors for more expansion!
"        saiwt div.foo#bar ->  <div class="foo" id="bar">foo</div>
"
" Also provides new text objects!
" > is( is the inside of a pair of braces
" > iss is bound below to do automatic matching
Plug 'machakann/vim-sandwich'

Plug 'tpope/vim-repeat'

" cml to comment out line, cmip to comment block
Plug 'tpope/vim-commentary'

" cmake support for invoking build etc
Plug 'vhdirk/vim-cmake'

" IDE stuff
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" - crs (coerce to snake_case)
" - MixedCase (crm)
" - camelCase (crc)
" - snake_case (crs)
" - UPPER_CASE (cru)
" - dash-case (cr-)
" - dot.case (cr.)
" - space case (cr<space>)
" - and Title Case (crt)
Plug 'tpope/vim-abolish'

" accounting
Plug 'ledger/vim-ledger'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" User defined textobjs, typically required by other plugins
Plug 'kana/vim-textobj-user'

" Haskell color and indentation
Plug 'neovimhaskell/haskell-vim'


" Vim-move lets you move selections directly without copy/paste
Plug 'matze/vim-move'

" Just some nice things for JS
" Plug 'pangloss/vim-javascript'

" Adds :FixWhitespace
Plug 'bronson/vim-trailing-whitespace'

" fzf.vim is a fuzzy finder (brew install fzf)
Plug '/usr/local/opt/fzf'
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

" let g:deoplete#enable_at_startup = 1

filetype plugin indent on

" Yup.
set encoding=utf-8

" Disable modelines since i dont use them and they can do crazy things
set modelines=0

" Yea it works for me
set autoindent

" Read unchanged files if they change on disk
set autoread

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

set backspace=indent,eol,start

" Line numbers in gutter are relative to current location (great for motions)
set relativenumber
set number " Will show the absolute number!

"
set cpoptions+=J

" Which shell to use
set shell=/usr/local/bin/fish
" set shell=/usr/bin/fish

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

nmap <c-p> :Files<cr>
xmap <c-p> :Files<cr>
omap <c-p> :Files<cr>
nmap <leader>p <plug>(fzf-maps-n)
xmap <leader>p <plug>(fzf-maps-x)
omap <leader>p <plug>(fzf-maps-o)
nnoremap <leader>d :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>


" List
set listchars=tab:→\ ,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
"set list

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
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set nowrap
set textwidth=110
set formatoptions=qrn1
" }}}

if has("gui_vimr")
set termguicolors
endif

" Backups, Undo {{{
set undodir=~/tmp/undo/     " undo files
set backupdir=~/tmp/backup/ " backups
set directory=~/tmp/swap/   " swap files
set backup                       " enable backups

set history=1000
set undofile
set undoreload=10000
" }}}


" Status line ------------------------------------------------------------- {{{

" Always show statusline
set laststatus=2

autocmd vimenter * colorscheme gruvbox

set background=dark
"set background=light
if (has("termguicolors"))
    set termguicolors
endif
syntax enable

if has("gui_vimr")
  " highlight Normal guibg=black guifg=white
  let g:airline_powerline_fonts = 1
endif

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'


let g:move_key_modifier = 'C'


" }}}


" }}}
" Buffer closing {{{

" BufOnly.vim  -  Delete all the buffers except the current/named buffer.
"
" Copyright November 2003 by Christian J. Robinson <infynity@onewest.net>
"
" Distributed under the terms of the Vim license.  See ":help license".
"
" Usage:
"
" :Bonly / :BOnly / :Bufonly / :BufOnly [buffer] 
"
" Without any arguments the current buffer is kept.  With an argument the
" buffer name/number supplied is kept.

command! -nargs=? -complete=buffer -bang Bonly
    \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang BOnly
    \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang Bufonly
    \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang BufOnly
    \ :call BufOnly('<args>', '<bang>')

function! BufOnly(buffer, bang)
	if a:buffer == ''
		" No buffer provided, use the current buffer.
		let buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A buffer number was provided.
		let buffer = bufnr(a:buffer + 0)
	else
		" A buffer name was provided.
		let buffer = bufnr(a:buffer)
	endif

	if buffer == -1
		echohl ErrorMsg
		echomsg "No matching buffer for" a:buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
			if a:bang == '' && getbufvar(n, '&modified')
				echohl ErrorMsg
				echomsg 'No write since last change for buffer'
							\ n '(add ! to override)'
				echohl None
			else
				silent exe 'bdel' . a:bang . ' ' . n
				if ! buflisted(n)
					let delete_count = delete_count+1
				endif
			endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count "buffer deleted"
	elseif delete_count > 1
		echomsg delete_count "buffers deleted"
	endif

endfunction


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

" vim-sandwich
" {}ass, {}iss, to grab outside/inside as a text object. e.g., dass to delete (foo)
xmap iss <Plug>(textobj-sandwich-auto-i)
xmap ass <Plug>(textobj-sandwich-auto-a)
omap iss <Plug>(textobj-sandwich-auto-i)
omap ass <Plug>(textobj-sandwich-auto-a)


" jsonpath
let g:jsonpath_register = '*'
au FileType json nnoremap <leader>go :call jsonpath#echo()<CR>
au FileType json nnoremap <leader>gg :call jsonpath#goto()<CR>


" Buffer motion {{{
" Easy buffer navigation
" Open a new buffer
map <F16> :enew<CR>

" Move between buffers
map <F17> :bprevious<CR>
map <F18> :bnext<CR>

" Close the current buffer and move to the previous one
map <F19> :bp <BAR> bd #<CR>
map <F15> :BufOnly <CR>

" Split vertical and horizontal with control-numpad
nnoremap <C-9> <C-W><C-V>
nnoremap <C-3> <C-W><C-S>

" Move between splits with control-numpad
nnoremap <C-8> <C-W><C-K>
nnoremap <C-6> <C-W><C-L>
nnoremap <C-2> <C-W><C-J>
nnoremap <C-4> <C-W><C-H>
" }}}
" }}}

" Various filetype-specific stuff ----------------------------------------- {{{

" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=syntax
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

" Javascript {{{

hi tsxTagName guifg=#E06C75
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxCloseTagName guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575
hi tsxAttrib guifg=#F8BD7F cterm=italic
hi tsxTypeBraces guifg=#999999
hi tsxTypes guifg=#666666
hi ReactState guifg=#C176A7
hi ReactProps guifg=#D19A66
hi ApolloGraphQL guifg=#CB886B
hi Events ctermfg=204 guifg=#56B6C2
hi ReduxKeywords ctermfg=204 guifg=#C678DD
hi ReduxHooksKeywords ctermfg=204 guifg=#C176A7
hi WebBrowser ctermfg=204 guifg=#56B6C2
hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66

autocmd BufNewFile,BufRead *.ts,*.tsx,*.js,*.jsx set filetype=typescript.tsx

let g:typescript_indent_disable = 1
autocmd FileType typescript :set makeprg=tsc
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

" Autoread changed files -------------------------------------------------- {{{

" Triger `autoread` when files changes on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
autocmd FileChangedShellPost *
    \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" }}}


" List
set listchars=tab:→\ ,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
"set list

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
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set nowrap
set textwidth=110
set formatoptions=qrn1
" }}}

if has("gui_vimr")
set termguicolors
endif

" Backups, Undo {{{
set undodir=~/tmp/undo/     " undo files
set backupdir=~/tmp/backup/ " backups
set directory=~/tmp/swap/   " swap files
set backup                       " enable backups

set history=1000
set undofile
set undoreload=10000
" }}}

" Colors & Theme ---------- {{{

autocmd vimenter * colorscheme gruvbox
set background=dark
"set background=light
if (has("termguicolors"))
    set termguicolors
endif
syntax enable

" }}}

" Status line ------------------------------------------------------------- {{{

" Always show statusline
set laststatus=2


if has("gui_vimr")
" highlight Normal guibg=black guifg=white
"let g:airline_theme = 'one'
let g:airline_powerline_fonts = 1
endif

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let g:move_key_modifier = 'C'
" }}}

" Tab Management {{{

set switchbuf=useopen,usetab,split
" Open current file on new tab
map <C-F16> :tab split<CR>
map <C-F17> :tabp<CR>
map <C-F18> :tabn<CR>
map <C-F19> :tabclose<CR>

map <F16> :split<CR>
map <F17> :sbprevious<CR>
map <F18> :sbnext<CR>
map <F19> :close<CR>
" }}}

" Buffer motion {{{
" Open a new buffer
map <S-F16> :enew<CR>

" Move between buffers
map <S-F17> :bprevious<CR>
map <S-F18> :bnext<CR>

" Close the current buffer and move to the previous one
map <S-F19> :bp <BAR> bd #<CR>

" Split vertical and horizontal with control-numpad
nnoremap <C-9> <C-W><C-V>
nnoremap <C-3> <C-W><C-S>

" Move between splits with control-numpad
nnoremap <C-8> <C-W><C-K>
nnoremap <C-6> <C-W><C-L>
nnoremap <C-2> <C-W><C-J>
nnoremap <C-4> <C-W><C-H>
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

" vim-sandwich
" {}ass, {}iss, to grab outside/inside as a text object. e.g., dass to delete (foo)
xmap iss <Plug>(textobj-sandwich-auto-i)
xmap ass <Plug>(textobj-sandwich-auto-a)
omap iss <Plug>(textobj-sandwich-auto-i)
omap ass <Plug>(textobj-sandwich-auto-a)


" }}}

" Various filetype-specific stuff ----------------------------------------- {{{

" C {{{

augroup ft_c
    au!
    au FileType c setlocal foldmethod=syntax
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

" Javascript {{{

hi tsxTagName guifg=#E06C75
hi tsxCloseString guifg=#F99575
hi tsxCloseTag guifg=#F99575
hi tsxCloseTagName guifg=#F99575
hi tsxAttributeBraces guifg=#F99575
hi tsxEqual guifg=#F99575
hi tsxAttrib guifg=#F8BD7F cterm=italic
hi tsxTypeBraces guifg=#999999
hi tsxTypes guifg=#666666
hi ReactState guifg=#C176A7
hi ReactProps guifg=#D19A66
hi ApolloGraphQL guifg=#CB886B
hi Events ctermfg=204 guifg=#56B6C2
hi ReduxKeywords ctermfg=204 guifg=#C678DD
hi ReduxHooksKeywords ctermfg=204 guifg=#C176A7
hi WebBrowser ctermfg=204 guifg=#56B6C2
hi ReactLifeCycleMethods ctermfg=204 guifg=#D19A66

autocmd BufNewFile,BufRead *.ts,*.tsx,*.js,*.jsx set filetype=typescript.tsx

let g:typescript_indent_disable = 1
autocmd FileType typescript :set makeprg=tsc
" }}}


" Coc {{{

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()


" gh - get hint on whatever's under the cursor
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

" List errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<cr>

" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" view all errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)
nmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)

" run code actions
vmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> <leader>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>] <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)


" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)


command! -nargs=0 Prettier :CocCommand prettier.formatFile

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



augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

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



command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case  -g "!{node_modules,.git}"  --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

" --- type & to search the word in all files in the current dir
nnoremap & :Rg <C-R><C-W><CR>
nnoremap <C-f> :Rg 
vnoremap <C-f> :Rg <C-R><C-W><CR>

source ~/tmp/user.vim
