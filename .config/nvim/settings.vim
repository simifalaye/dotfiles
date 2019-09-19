"---------- Globals ----------"

" Use leader to specify extra keybinding
let mapleader = " "
let vim_home_dir = !empty($VIM_HOME_DIR) ? $VIM_HOME_DIR : "~/.vim"
let fzf_src_dir = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"

" Set directories
let vimplugdir=vim_home_dir . "/plugged"
let vimautoloaddir=$EDITOR == "nvim" ? $HOME . "/.local/share/nvim/site/autoload" : vim_home_dir . "/autoload"
let vimundodir=vim_home_dir . "/undodir"
let fzfsourcedir=fzf_src_dir

" Set tags file locations for ctags
set tags=./tags,./.git/tags;
" Set clipboard
set clipboard=unnamedplus

"---------- Work standard vim setup ----------"

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

"---------- Files, backups and undo ----------"

" Reload files changed outside vim
set autoread
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
" Turn persistent undo on. Means that you can undo even when you close a buffer/VIM
if !isdirectory(vimundodir)
    call mkdir(vimundodir, "", 0755)
endif
execute "set undodir=".vimundodir
set undofile
" :W sudo saves the file
if !exists(':W')
    command W w !sudo tee % > /dev/null
endif
" Remove escape delay
set timeoutlen=1000
set ttimeoutlen=0

"---------- User Interface ----------"

set hidden
" Display line numbers
set number
" Allow mouse usage
set mouse=a
" Buf file
au! BufNewFile,BufRead *.rockspec setf lua
" Set text line width for python files
au BufRead,BufNewFile *.py setlocal textwidth=80
" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" VimSplits
set splitbelow
set splitright
set fillchars=""
