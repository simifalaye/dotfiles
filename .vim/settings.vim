"-- Globals --"

" Use leader to specify extra keybinding
let mapleader = " "
" Set vim directories
" Avoid using standard Vim directory names like 'plugin'
let vimplugdir='~/.vim/plugged'
let vimautoloaddir='~/.vim/autoload'
" Set ultisnips dir
let ultisnipsdirsave="~/.vim/UltiSnips"
" fzf source dir
let fzfsourcedir="~/.fzf"

" Set tags file locations for ctags
set tags=./tags,./.git/tags;

"-- Work standard vim setup --"

filetype on         "identify file types
filetype indent on  "indent based on filetype
filetype plugin on  "enable file-specific plugins
syntax on           "filetype syntax highlighting
set expandtab       "Turn tabs into spaces
set tabstop=4       "use 4-space tabs when [tab] is pressed
set shiftwidth=4    "use 4-space tabs when reading files
set showmatch       "highlight the bracket match
set ruler           "always show the bottom line
set showmode        "show mode (INSERT/OVER) in ruler
set autoindent      "auto-indent when going to a new line
set smartindent     "guess the indent level based on code
set showcmd         "show partial cmd in ruler
set ignorecase      "ignore case when searching (search in all lower case!)
set smartcase       "If upper case is provided in searching, search for it
set incsearch       "highlight search terms as you search
set hlsearch        "highlight search results
set backspace=indent,eol,start "for ssh terminals
set vb t_vb=        "shush, no beep
set scrolloff=5     "keep 5 lines of context at end of file when scrolling
set complete=.,w,b,u,U,t,i,d  " do lots of scanning on tab completion
autocmd BufWritePre * :%s/\s\+$//e "remove trailing white space on save
highlight SpecialKey ctermfg=1
set list
set listchars=tab:T>
set encoding=utf8

"-- Files, backups and undo --"

" Reload files changed outside vim
set autoread
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
" Turn persistent undo on. Means that you can undo even when you close a buffer/VIM
try
    silent !mkdir ~/.vim/undodir > /dev/null 2>&1
    set undodir=~/.vim/undodir
    set undofile
catch
endtry
" :W sudo saves the file
" (useful for handling the permission-denied error)
if !exists(':W')
    command W w !sudo tee % > /dev/null
endif

"-- User Interface --"

set hidden
" Display line numbers
set number relativenumber
" Allow mouse usage
set mouse=a
set ttymouse=xterm2
" Buf file
au! BufNewFile,BufRead *.rockspec setf lua
" Set text line width for python files
au BufRead,BufNewFile *.py setlocal textwidth=80
" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
