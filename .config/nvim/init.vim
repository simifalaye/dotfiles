" vim:fdm=marker

" Variables {{{

let mapleader        = " "
let g:vimhomedir     = has('nvim') ? "~/.config/nvim" : "~/.vim"
let g:fzfsourcedir   = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"
let g:vimplugdir     = g:vimhomedir . "/plugged"
let g:vimautoloaddir = g:vimhomedir . "/autoload"
let g:sessiondir     = g:vimhomedir . "/session"
let g:is_unix        = has('unix')
let g:is_gui         = has('gui_running')
let g:is_wsl         = !empty($IS_WSL_DEVICE) ? 1 : 0

" }}}
" Settings {{{

" General settings
" ----------------
" Read documentation about each option by executing :h <option>
" or "K" in normal mode when cursor is over the setting

filetype on                    " identify file types
filetype indent on             " indent based on filetype
filetype plugin on             " enable file-specific plugins
set shell=/bin/bash            " set the shell to use
set expandtab                  " turn tabs into spaces
set tabstop=4                  " use 4-space tabs when [tab] is pressed
set shiftwidth=4               " use 4-space tabs when reading files
set showmatch                  " highlight the bracket match
set ruler                      " always/don't show the bottom line
set noshowmode                 " [don't] show mode (INSERT/OVER) in ruler
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
set timeoutlen=1000            " remove escape delay
set ttimeoutlen=0              " remove escape delay
set tags=./tags,./.git/tags;   " set tags file locations for ctags
set wildmenu                   " enable tab completion in commands
set wildmode=longest:full,full " settings for how to complete matched strings
set lazyredraw                 " don't redraw when we don't have to
set nostartofline              " don't reset cursor to start of line when moving
set cmdheight=1                " bottom section height
set selection=old              " no new line when using $
set conceallevel=2             " Allow concealing of certain syntax
set backspace=indent,eol,start " make backspace behave in a sane manner

" Files and buffers
" -------------------

set hidden        " Allow buffers to remain hidden when not in use
set autoread      " Reload files changed outside vim
set nobackup      " Turn backup off
set noswapfile    " Turn swap files off
set nowritebackup " Turn write backup off
set undofile      " Turn on undo file

" User Interface
" ----------------

set number         " Display line numbers
set relativenumber " Disply line numbers relative to current line
set mouse=a        " Allow mouse usage
set list           " Show specific characters
set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
set splitbelow     " Fix splits
set splitright     " Fix splits
set fillchars=""   " Fix splits
set shortmess+=c   " Avoid 'hit enter' messages
set updatetime=300 " Default is 4000, lower it for better performance
set signcolumn=no  " Don't like the extra space

" History
" ---------

set history=1000                    " Remember more commands
if has('persistent_undo')
  set undofile                      " Persistent undo
  set undodir=~/.cache/vim/undo     " Set undo directory
  set undolevels=1000               " Max number of changes
  set undoreload=10000              " Max lines to save for undo on a buffer reload
endif
if has('unnamedplus')
  set clipboard=unnamedplus " set clipboard to use
else
  set clipboard=unnamed
endif

" Vim-only overrides
" --------------------

if !has("nvim")
  set laststatus=2
  set smarttab
  set ttyfast
  set nocompatible
endif

" }}}
" Plugins {{{

" Disable unused built-in plugins.
let g:loaded_gzip              = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_2html_plugin      = v:true
let g:loaded_tutor_mode_plugin = v:true

" download vim-plug if not installed yet
call helpers#utils#getVimPlug(g:vimautoloaddir)
call plug#begin(g:vimplugdir)

" Text manipulation
" -------------------
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'

" Integration Utilities
" -----------------------
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

" Files / Buffers
" -----------------
Plug 'junegunn/fzf', {'dir': g:fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  let NERDTreeShowHidden=1

" UI
" ----
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'

" Code completion / Languages
" -----------------------------
Plug 'derekwyatt/vim-fswitch'
Plug 'kergoth/vim-bitbake' | Plug 'wgwoods/vim-systemd-syntax'
Plug 'sheerun/vim-polyglot'
    let g:vim_markdown_folding_disabled     = v:true
    let g:vim_markdown_auto_insert_bullets  = v:false
    let g:vim_markdown_new_list_item_indent = v:false
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Call setup functions
call helpers#coc#plugins()
call helpers#fzf#setup()
call helpers#startify#setup()

" }}}
" Mappings & Commands {{{

" Delete all buffer but current
command! BufOnly silent! execute "%bd|e#|bd#"
" :W sudo saves the file (useful for handling the permission-denied error)
command! W! execute 'w !sudo tee % > /dev/null' <bar> edit!
" Vim config
nnoremap <localleader>r :so $MYVIMRC<bar>echo "vimrc reloaded"<CR>
" Save, close & quit
nnoremap <leader>w  :update<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>Q  :qa<CR>
nnoremap <silent><localleader>d :bprevious<bar>bdelete #<CR>
nnoremap <silent><localleader>x :windo lclose<bar>cclose<CR>

" Remaps
" -------
inoremap jk <Esc>
nnoremap ;  :
nnoremap :  ;
nnoremap Q  @q
nnoremap j  gj
nnoremap k  gk
vnoremap y  ygv<Esc>
nnoremap Y  y$
nnoremap n  nzz
nnoremap N  Nzz
nnoremap /  ms/\v
nnoremap ?  ms?\v
vnoremap <  <gv
vnoremap >  >gv
nnoremap p  p`[v`]=
nnoremap c  "_c
nnoremap C  "_C
nnoremap cc "_cc

" Editing
" ---------
call helpers#coc#mappings()
" Align text & underline titles
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap gu yyp0v$r- | nmap gU yyp0v$r=
" Toggle highlight & select pasted text
nnoremap <leader>/ :nohl<CR>
nnoremap <leader>v `[v`]
" Auto close & switch to last buffer
inoremap {<CR>            {<CR>}<Esc>O
inoremap {;               {<CR>};<Esc>O
nnoremap <leader><leader> <c-^>

" Files, Buffers, Splits and Tabs
" --------------------------------
" Explorer & navigation
nnoremap <leader>; :NERDTreeToggle<CR>
nnoremap <leader>: :NERDTreeFind<CR>
nnoremap <leader>s :FSHere<CR>
nnoremap <C-h> <C-w>h | nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k | nnoremap <C-j> <C-w>j
nnoremap <leader>- <C-w>s | nnoremap <leader>\ <C-w>v
" Fzf
nnoremap <silent><C-p> :Files<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent>,     :Buffers<CR>
nnoremap <silent>_     :Marks<CR>
" Git
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gis :Gstatus<CR>
" Make executable
nnoremap <leader>x :! chmod +x %<CR>
" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" }}}
" UI {{{

" Color support
" ---------------
" Fixes bckgrd color issues (wsl support)
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif
" Enable true color support
set t_Co=256
if (has("termguicolors"))
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Set theme
" -----------
set background=dark
let base16colorspace=256
colorscheme base16-gruvbox-dark-hard
exe 'hi LineNr guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
exe 'hi SignColumn guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00

" Statusline
" ------------
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified', 'cocstatus'] ],
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*FugitiveHead")&&""!=FugitiveHead()?" ".FugitiveHead():""}',
      \   'cocstatus': '%{coc#status()}'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
" Remove the background color from the statusline and tabline
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle

" }}}}
" Autocommands {{{

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste
" Jump to last known position and center buffer around cursor.
augroup jumplast
  autocmd!
  autocmd BufWinEnter ?* call helpers#utils#jumplast()
augroup end
" Remove trailing whitespace on save
augroup trailingwhitespace
  autocmd!
  autocmd BufWritePre * call helpers#utils#stripTrailingWhitespace()
augroup end
" File type settings
augroup filetypesettings
  autocmd!
  autocmd FileType markdown           let b:indentLine_enabled = 0
  autocmd Filetype gitcommit,markdown setl spell        tw=72
  autocmd FileType c,cpp              setl shiftwidth=4 tabstop=4 commentstring=//\ %s
  autocmd FileType java               setl shiftwidth=2 tabstop=2 commentstring=//\ %s
  autocmd FileType vim                setl shiftwidth=2 tabstop=2
  autocmd FileType sh,zsh             setl shiftwidth=4 tabstop=4
augroup end

" }}}
