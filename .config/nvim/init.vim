" vim:fdm=marker

" Globals {{{

let mapleader        = " "
let g:vimhomedir     = has('nvim') ? "~/.config/nvim" : "~/.vim"
let g:vimplugdir     = g:vimhomedir . "/plugged"
let g:vimplugconfdir = g:vimhomedir . "/conf"
let g:vimautoloaddir = g:vimhomedir . "/autoload"

" }}}
" Settings {{{

" General settings
" ----------------
" Read documentation about each option by executing :h <option>
" or "K" in normal mode when cursor is over the setting

set expandtab                  " turn tabs into spaces
set tabstop=4                  " use 4-space tabs when [tab] is pressed
set shiftwidth=4               " use 4-space tabs when reading files
set softtabstop=4              " number of spaces that a <Tab> counts for
set showmatch                  " highlight the bracket match
set noshowmode                 " [don't] show mode (INSERT/OVER) in ruler
set smartindent                " guess the indent level based on code
set ignorecase                 " ignore case when searching (search in all lower case!)
set smartcase                  " if upper case is provided in searching, search for it
set scrolloff=5                " keep 5 lines of context at end of file when scrolling
set complete=.,w,b,u,U,t,i,d   " do lots of scanning on tab completion
set timeoutlen=1000            " remove escape delay
set ttimeoutlen=0              " remove escape delay
set wildmode=longest:full,full " settings for how to complete matched strings
set lazyredraw                 " don't redraw when we don't have to
set cmdheight=1                " bottom section height
set selection=old              " no new line when using $
set conceallevel=2             " Allow concealing of certain syntax

" Files and buffers
" -------------------

set hidden        " Allow buffers to remain hidden when not in use
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
set noequalalways  " Keep windows the same size
set shortmess+=c   " Avoid 'hit enter' messages
set updatetime=300 " Default is 4000, lower it for better performance
set signcolumn=no  " Don't like the extra space
set sel=inclusive  " Include last character in visual selection
set foldlevel=20   " Expand folds by default
set pastetoggle=<F2>

" History
" ---------

if has('persistent_undo')
  set undofile                  " Persistent undo
  set undodir=~/.cache/vim/undo " Set undo directory
  set undolevels=1000           " Max number of changes
  set undoreload=10000          " Max lines to save for undo on a buffer reload
endif
set clipboard=unnamed           " set clipboard to use

" }}}
" Functions {{{

""
" Gets vim-plug from github
"
" @param {string} dir: directory to put vim-plug in
""
fun! s:getVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfun

""
" Sources the files in given directory
" @param {string} dir: directory of files
""
fun! s:sourceConfigFilesIn(dir)
  let dir_glob = a:dir . '/*'
  for config_file in split(glob(dir_glob), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfun

""
" Zoom into a pane, making it full screen (in a tab) Triggering the plugin
" again from the zoomed in tab brings it back to its original pane location
""
fun s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, ' . bufnr('') . ') >= 0')) > 1
    tabclose
  endif
endfun

""
" Jump to last known position and center buffer around cursor.
""
fun! s:jumplast() abort
  if empty(&buftype) && index(['diff', 'gitcommit'], &filetype, 0, v:true) == -1
    if line("'\"") >= 1 && line("'\"") <= line('$')
      execute 'normal! g`"zz'
    endif
  endif
endfun

""
" Remove trailing whitespace
""
fun! s:stripTrailingWhitespace() abort
  " Don't strip on these filetypes
  if &ft =~ 'ruby\|javascript\|perl\|markdown\|gitsendemail\|gitcommit'
    return
  endif
  %s/\s\+$//e
endfun

""
" Don't close window, when deleting a buffer
""
fun! s:bufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")
  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif
  if bufnr("%") == l:currentBufNum
    new
  endif
  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfun

" }}}
" Plugins {{{

" Download vim-plug if not installed yet
call s:getVimPlug(g:vimautoloaddir)

" Load plugins
call plug#begin(g:vimplugdir)
  call s:sourceConfigFilesIn(g:vimplugconfdir)
call plug#end()

" }}}
" Mappings & Commands {{{

" Remaps
nnoremap j  gj
nnoremap k  gk
nnoremap Q  @q
vnoremap Q  :norm @q<cr>
vnoremap y  ygv<Esc>
nnoremap Y  y$
nnoremap n  nzz
nnoremap N  Nzz
nnoremap /  ms/\v
nnoremap ?  ms?\v
vnoremap <  <gv
vnoremap >  >gv
nnoremap p  p`[v`]=
xnoremap il g_o0
onoremap il :normal vil<CR>

" Vim Plug
nnoremap <localleader>r :so $MYVIMRC<bar>echo "vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>:PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>:PlugClean<CR>
nnoremap <localleader>u :so $MYVIMRC<bar>:PlugUpdate<CR>

" Save, close & quit
nnoremap <leader>s :update<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>b :call <SID>bufcloseCloseIt()<CR>

" Toggle highlight & select pasted text
nnoremap <leader>/ :nohl<CR>
nnoremap <leader>p `[v`]

" Switch to last buffer
nnoremap <leader><leader> <c-^>

" Split & open quick fix
nnoremap <leader>- <C-w>s
nnoremap <leader>\| <C-w>v
nnoremap <leader>o :copen<CR>

" Make executable
nnoremap <leader>x :! chmod +x %<CR>

" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Zoom
nnoremap <leader>+ :call <SID>zoom()<CR>

" Underline text
nmap gu yyp0v$r- | nmap gU yyp0v$r=

" Scroll the viewport faster
nnoremap <Down> 3<C-e>
nnoremap <Up> 3<C-y>

" Add [count] lines above and below cursor
nnoremap ]<space> o<ESC>'[k
nnoremap [<space> O<ESC>j

" }}}
" UI {{{

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

" Set Theme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
  exe 'hi LineNr guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
  exe 'hi SignColumn guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
endif

" }}}}
" Autocommands {{{

" Leave paste mode when leaving insert mode
au InsertLeave * set nopaste
" Jump to last known position and center buffer around cursor.
augroup jumplast
  au!
  au BufWinEnter ?* call s:jumplast()
augroup end
" Remove trailing whitespace on save
augroup trailingwhitespace
  au!
  au BufWritePre * call s:stripTrailingWhitespace()
augroup end
" }}}
