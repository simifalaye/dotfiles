" Globals
" -------
" Variables that will be used in the whole vim config

" Use leader to specify extra keybinding
let mapleader = " "
" Get useful env variables if set
let vimhomedir = !empty($VIM_HOME_DIR) ? $VIM_HOME_DIR : "~/.vim"
let fzfsourcedir = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"
" Set directory variables
let vimplugdir=vimhomedir . "/plugged"
let vimautoloaddir=$EDITOR == "nvim" ? $HOME . "/.local/share/nvim/site/autoload" : vimhomedir . "/autoload"
let vimundodir=vimhomedir . "/undodir"

" General settings
" ----------------
" Read documentation about each option by executing :h <option>

filetype on                    " identify file types
filetype indent on             " indent based on filetype
filetype plugin on             " enable file-specific plugins
syntax on                      " filetype syntax highlighting
set expandtab                  " Turn tabs into spaces
set tabstop=4                  " use 4-space tabs when [tab] is pressed
set shiftwidth=4               " use 4-space tabs when reading files
set showmatch                  " highlight the bracket match
set ruler                      " always show the bottom line
set showmode                   " show mode (INSERT/OVER) in ruler
set autoindent                 " auto-indent when going to a new line
set smartindent                " guess the indent level based on code
set showcmd                    " show partial cmd in ruler
set ignorecase                 " ignore case when searching (search in all lower case!)
set smartcase                  " If upper case is provided in searching, search for it
set incsearch                  " highlight search terms as you search
set hlsearch                   " highlight search results
set backspace=indent,eol,start " for ssh terminals
set vb t_vb=                   " shush, no beep
set scrolloff=5                " keep 5 lines of context at end of file when scrolling
set complete=.,w,b,u,U,t,i,d   " do lots of scanning on tab completion
set encoding=utf8              " default character encoding
set clipboard=unnamedplus      " set clipboard to use
set timeoutlen=1000            " remove escape delay
set ttimeoutlen=0              " remove escape delay
set tags=./tags,./.git/tags;   " Set tags file locations for ctags
set wildmenu                   " enable tab completion in commands
set wildmode=longest:full,full " settings for how to complete matched strings

" Files and buffers
" -----------------

set ttyfast
" Allow buffers to remain hidden when not in use
set hidden
" Reload files changed outside vim
set autoread
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
set nowritebackup
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

" User Interface
" --------------

" Display line numbers
set number
set relativenumber
" Allow mouse usage
set mouse=a
" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
" Show specific characters
set list
set listchars=tab:T>,trail:.,extends:>,precedes:<,nbsp:+
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" VimSplits
set splitbelow
set splitright
set fillchars=""
" Disable Netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Helpers
" -------

" abbreviations (try not to use common words)
iab tdate <c-r>=strftime("%Y-%m-%d")<cr>
