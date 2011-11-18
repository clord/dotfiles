" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible
set encoding=utf-8

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Editing behaviour {{{
filetype on                     " set filetype stuff to on
filetype plugin on
filetype indent on

set nowrap                      " don't wrap lines
set tabstop=3                   " a tab is three spaces
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set cindent                     " Try to intelligently indent c code
"set number                      " always show line numbers
set shiftwidth=3                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                   " set show matching parenthesis
set foldenable                  " enable folding
set foldmethod=marker           " detect triple-{ style fold markers
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                                " which commands trigger auto-unfold
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
"set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set expandtab                   " insert spaces for tabs
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set nolist                      " don't show invisible characters by default
set listchars=trail:·,precedes:«,extends:#,nbsp:·,tab:▸\
set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
set mouse=a                     " enable using the mouse if terminal emulator
                                "    supports it (xterm does)

" Speed up scrolling of the viewport slightly
nnoremap <C-e> 4<C-e>
nnoremap <C-y> 4<C-y>
" }}}


" Editor layout {{{
set termencoding=utf-8
set encoding=utf-8
set lazyredraw                  " don't update the display while executing macros
set laststatus=2                " tell VIM to always put a status line in, even
                                "    if there is only one window
set cmdheight=1                 " use a status bar that is 2 rows high
set ruler
" }}}

" Vim behaviour {{{
set hidden                      " hide buffers instead of closing them this
                                "    means that the current buffer can be put
                                "    to background without being written; and
                                "    that marks and undo history are preserved
set switchbuf=useopen,usetab    " reveal already opened files from the
                                " quickfix window instead of opening new
                                " buffers
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set nobackup                    " do not keep backup files, it's 70's style cluttering
set noswapfile                  " do not write annoying intermediate swap files,
                                "    who did ever restore from swap files anyway?
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
                                " store swap files in one of these directories
set viminfo='20,\"80            " read/write a .viminfo file, don't store more
                                "    than 80 lines of registers
set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
                                "    first full match
set wildignore=*.swp,*.bak,*.o,*.d,*.u
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
                                "    this also shows visual selection info
set modeline                    " allow files to include a 'mode line', to
                                "    override vim defaults
set modelines=5                 " check the first 5 lines for a modeline

set shortmess=atI
" }}}

" Highlighting {{{
if &t_Co >= 256 || has("gui_running")
   "colorscheme mustang
   colorscheme solarized
endif

if colors_name == 'solarized'
   if has('gui_macvim')
      set transparency=0
   endif
   if !has('gui_running') && $TERM_PROGRAM == 'Apple_Terminal'
      let g:solarized_termcolors = &t_Co
      let g:solarized_termtrans = 1
      colorscheme solarized
   endif
   call togglebg#map("<F2>")
endif

if has("gui_running")
    set guioptions=egmrt
endif

if &t_Co > 2 || has("gui_running")
   syntax on                    " switch syntax highlighting on, when the terminal has colors
endif
" }}}

" Shortcut mappings {{{
" Since I never use the ; key anyway, this is a real optimization for almost
" all Vim commands, since we don't have to press that annoying Shift key that
" slows the commands down
nnoremap ; :

" Use Q for formatting the current paragraph (or visual selection)
vmap Q gq
nmap Q gqap

" make p in Visual mode replace the selected text with the yank register
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
nnoremap ' `
nnoremap ` '

" Change the mapleader from \ to ,
let mapleader=","


" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Complete whole filenames/lines with a quicker shortcut key in insert mode
imap <C-f> <C-x><C-f>
imap <C-l> <C-x><C-l>

" Use ,d (or ,dd or ,dj or 20,dd) to delete a line without adding it to the
" yanked stack (also, in visual mode)
nmap <silent> ,d "_d
vmap <silent> ,d "_d

" Edit the vimrc file
nmap <silent> ,ev :e $MYVIMRC<CR>
nmap <silent> ,sv :so $MYVIMRC<CR>

" Clears the search register
nmap <silent> ,/ :let @/=""<CR>

" Quick alignment of text
nmap ,al :left<CR>
nmap ,ar :right<CR>
nmap ,ac :center<CR>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null
" }}}

nmap <silent> ,[ :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <silent> ,{ :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <silent> ,\ :cs find c <C-R>=expand("<cword>")<CR><CR>

" Working with tabs {{{
set tabpagemax=10    " use at most 10 tabs
nmap ,t <Esc>:tabedit .<CR>
nmap ,T <Esc>:tabnew<CR>
nmap gt <C-w>gf
nmap gT <C-w>gF
nmap ,1 :tabn 1<CR>
nmap ,2 :tabn 2<CR>
nmap ,3 :tabn 3<CR>
nmap ,4 :tabn 4<CR>
nmap ,5 :tabn 5<CR>
nmap ,6 :tabn 6<CR>
nmap ,7 :tabn 7<CR>
nmap ,8 :tabn 8<CR>
nmap ,9 :tabn 9<CR>
nmap ,0 :tabn 10<CR>
nmap ,<Left> :tabprevious<CR>
nmap ,<Right> :tabnext<CR>

" Pull word under cursor into LHS of a substitute
nmap ,z :%s#\<<C-r>=expand("<cword>")<CR>\>#
" }}}


" TagList settings {{{
nmap ,l :TlistClose<CR>:TlistToggle<CR>
nmap ,L :TlistClose<CR>

" quit Vim when the TagList window is the last open window
let Tlist_Exit_OnlyWindow=1         " quit when TagList is the last open window
let Tlist_GainFocus_On_ToggleOpen=1 " put focus on the TagList window when it opens
"let Tlist_Process_File_Always=1     " process files in the background, even when the TagList window isn't open
"let Tlist_Show_One_File=1           " only show tags from the current buffer, not all open buffers
let Tlist_WinWidth=40               " set the width
let Tlist_Inc_Winwidth=1            " increase window by 1 when growing

" shorten the time it takes to highlight the current tag (default is 4 secs)
" note that this setting influences Vim's behaviour when saving swap files,
" but we have already turned off swap files (earlier)
"set updatetime=1000

" the default ctags in /usr/bin on the Mac is GNU ctags, so change it to the
" exuberant ctags version in /usr/local/bin
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

" show function/method prototypes in the list
let Tlist_Display_Prototype=1

" don't show scope info
let Tlist_Display_Tag_Scope=0

" show TagList window on the right
let Tlist_Use_Right_Window=1

" }}}

" Conflict markers {{{
" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" shortcut to jump to next conflict marker
nmap <silent> ,c /^\(<\\|=\\|>\)\{7\}\([^=].\+\)\?$<CR>
" }}}

" Filetype specific handling {{{
" only do this part when compiled with support for autocommands
if has("autocmd")

    augroup vim_files
        au!
        autocmd filetype vim set expandtab    " disallow tabs in Vim files
    augroup end

   autocmd filetype fortran,rst let fortran_free_source=1
   autocmd filetype c,rst set expandtab


   " bind <F1> to show the keyword under cursor
   " general help can still be entered manually, with :h
   autocmd filetype vim noremap <F1> <Esc>:help <C-r><C-w><CR>
   autocmd filetype vim noremap! <F1> <Esc>:help <C-r><C-w><CR>

   " render YAML front matter inside Textile documents as comments
   autocmd filetype textile syntax region frontmatter start=/\%^---$/ end=/^---$/
   autocmd filetype textile highlight link frontmatter Comment

endif " has("autocmd")
" }}}

" Auto save/restore {{{
"au BufWritePost *.* silent mkview!
"au BufReadPost *.* silent loadview

" Quick write session with F2
map <F2> :mksession! .vim_session<CR>
" And load session with F3
map <F3> :source .vim_session<CR>
" }}}

map <F5> :NERDTreeToggle<CR>

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

let g:display_num = substitute($DISPLAY, "^[[:alpha:]]*:\([[:digit:]]\+\)\.[[:digit:]]\+$", "\1" , "")

" Extra vi-compatibility {{{
" set extra vi-compatible options
set cpoptions+=$     " when changing a line, don't redisplay, but put a '$' at
                     " the end during the change
set formatoptions-=o " don't start new lines w/ comment leader on pressing 'o'
au filetype vim set formatoptions-=o
                     " somehow, during vim filetype detection, this gets set,
                     " so explicitly unset it again for vim files
" }}}

" Extra user or machine specific settings {{{
source ~/tmp/user.vim
" }}}
