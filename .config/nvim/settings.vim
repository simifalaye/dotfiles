" Globals
" -------
" Variables that will be used in the whole vim config

let mapleader = " "
let vimhomedir = has('nvim') ? "~/.config/nvim" : "~/.vim"
let fzfsourcedir = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"
let vimplugdir=vimhomedir . "/plugged"
if has('nvim')
  let vimautoloaddir = $HOME . "/.local/share/nvim/site/autoload"
else
  let vimautoloaddir = vimhomedir ."/autoload"
endif

" General settings
" ----------------
" Read documentation about each option by executing :h <option>
" or "K" in normal mode when cursor is over the setting

filetype on                    " identify file types
filetype indent on             " indent based on filetype
filetype plugin on             " enable file-specific plugins
set expandtab                  " turn tabs into spaces
set showmatch                  " highlight the bracket match
set ruler                      " always show the bottom line
set showmode                   " show mode (INSERT/OVER) in ruler
set autoindent                 " auto-indent when going to a new line
set smartindent                " guess the indent level based on code
set showcmd                    " show partial cmd in ruler
set ignorecase                 " ignore case when searching (search in all lower case!)
set smartcase                  " if upper case is provided in searching, search for it
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
set tags=./tags,./.git/tags;   " set tags file locations for ctags
set wildmenu                   " enable tab completion in commands
set wildmode=longest:full,full " settings for how to complete matched strings
set lazyredraw                 " don't redraw when we don't have to
set nostartofline              " don't reset cursor to start of line when moving
set cmdheight=1                " bottom section height

" Files and buffers
set hidden        " Allow buffers to remain hidden when not in use
set autoread      " Reload files changed outside vim
set nobackup      " Turn backup off
set noswapfile    " Turn swap files off
set nowritebackup " Turn write backup off
set undofile      " Turn on undo file

" User Interface
set number                         " Display line numbers
set relativenumber                 " Disply line numbers relative to current line
set mouse=a                        " Allow mouse usage
autocmd BufWritePre * :%s/\s\+$//e " Remove trailing whitespace on save
set list                           " Show specific characters
set listchars=tab:T>,trail:.,extends:>,precedes:<,nbsp:+
set splitbelow                     " Fix splits
set splitright                     " Fix splits
set fillchars=""                   " Fix splits

" History
set history=1000                  " Remember more commands
if has('persistent_undo')
    set undofile                  " Persistent undo
    set undodir=~/.cache/vim/undo " Set undo directory
    set undolevels=1000           " Max number of changes
    set undoreload=10000          " Max lines to save for undo on a buffer reload
endif

" Vim-only overrides
if !has("nvim")
  filetype plugin indent on
  syntax enable
  set laststatus=2
  set smarttab
  set ttyfast
endif

" Disable Netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" File type settings
autocmd Filetype gitcommit,mail,md setlocal spell textwidth=72

" Abbreviations (try not to use common words)
iab tdate <c-r>=strftime("%Y-%m-%d")<cr>
iab todo: @TODO:
iab fixme: @FIXME:
