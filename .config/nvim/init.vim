" vim:fdm=marker

" Variables {{{

let mapleader        = " "
let g:vimhomedir     = has('nvim') ? "~/.config/nvim" : "~/.vim"
let g:vimplugdir     = g:vimhomedir . "/plugged"
let g:vimautoloaddir = g:vimhomedir . "/autoload"
let g:sessiondir     = g:vimhomedir . "/session"
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
set pastetoggle=<F2>

" History
" ---------

set history=1000                " Remember more commands
if has('persistent_undo')
  set undofile                  " Persistent undo
  set undodir=~/.cache/vim/undo " Set undo directory
  set undolevels=1000           " Max number of changes
  set undoreload=10000          " Max lines to save for undo on a buffer reload
endif

" }}}
" Plugins {{{

" Disable unused built-in plugins.
let g:loaded_gzip              = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_2html_plugin      = v:true
let g:loaded_tutor_mode_plugin = v:true

" download vim-plug if not installed yet
call functions#getVimPlug(g:vimautoloaddir)
call plug#begin(g:vimplugdir)
Plug 'airblade/vim-rooter'
  let g:rooter_silent_chdir = 1
  let g:rooter_patterns     = ['oe-workdir/', 'src/', '.git/']
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', {'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
  let g:fzf_colors         = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }
  let g:fzf_action         = {
        \ 'ctrl-q': function('functions#build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }
  let g:fzf_layout         = { 'down': '~40%' }
  let g:fzf_buffers_jump   = v:true
  let g:fzf_preview_window = ''
  let g:fzf_history_dir    = '~/.local/share/fzf-history'
  " CMD => Find
  if executable('rg')
    let s:grep_cmd = 'rg --column --line-number --no-heading
          \ --fixed-strings
          \ --ignore-case
          \ --hidden
          \ --follow
          \ --glob "!.git/*"
          \ --color "always" '
    command! -bang -nargs=* Find
          \ call fzf#vim#grep(s:grep_cmd . shellescape(<q-args>) . '| tr -d "\017"', 1, <bang>0)
  endif
Plug 'mhinz/vim-startify'
  let g:startify_change_to_dir       = v:false
  let g:startify_enable_special      = v:false
  let g:startify_relative_path       = v:true
  let g:startify_update_oldfiles     = v:true
  let g:startify_session_dir         = g:sessiondir
  let g:startify_session_persistence = v:true
  let g:startify_bookmarks           = [
        \ {'n': '~/.config/nvim/init.vim'},
        \ {'z': '~/.config/zsh/.zshrc'},
        \ {'p': '~/.config/shell/shell-profile'}
        \ ]
  let g:startify_lists = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]
  let g:startify_commands = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = [
        \ 'coc-clangd',
        \ 'coc-explorer',
        \ 'coc-json',
        \ 'coc-lua',
        \ 'coc-rls',
        \ 'coc-snippets',
        \ 'coc-sh',
        \ 'coc-word',
        \]
Plug 'rstacruz/vim-closer'
Plug 'sheerun/vim-polyglot'
  let g:vim_markdown_folding_disabled     = v:true
  let g:vim_markdown_auto_insert_bullets  = v:false
  let g:vim_markdown_new_list_item_indent = v:false
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch', {'on': [ 'Make', 'Dispatch', 'Start' ]}
  let g:dispatch_no_maps = 1
Plug 'tpope/vim-fugitive', {'on': [ 'Gstatus', 'Gblame', 'Gdiff' ]}
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/doxygentoolkit.vim', {'for': ['cpp', 'c']}
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'wellle/targets.vim'
call plug#end()
" Osc52 support for vim
exec "source " . g:vimautoloaddir . "/osc52.vim"

" }}}
" Mappings & Commands {{{

" Remaps
inoremap jk <Esc>
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
nmap     x  <Plug>ReplaceWithRegisterOperator
nmap     xx <Plug>ReplaceWithRegisterLine
xmap     x  <Plug>ReplaceWithRegisterVisual

" Vim config
nnoremap <localleader>r :so $MYVIMRC<bar>echo "vimrc reloaded"<CR>

" Save, close & quit
nnoremap <leader>w :update<CR>
nnoremap <leader>d :call functions#bufcloseCloseIt()<CR>
nnoremap <leader>q :q<CR>
nnoremap <C-q>     :confirm qall<CR>

" Copy to system cliboard using osc52
vmap <C-c> y:call SendViaOSC52(getreg('"'))<cr>

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
nnoremap <leader>i :e <C-R>=expand("%:p:h") . "/" <CR>

" Zoom
nnoremap <leader>z :call functions#zoom()<CR>

" Underline text
nmap gu yyp0v$r- | nmap gU yyp0v$r=

" CoC:
" Use tab to cycle through completion items and <CR> to accept
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ functions#checkBackspace() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call functions#cocShowDocumentation()<CR>
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" CocList mappings
nnoremap <silent><leader>cd :<C-u>CocList diagnostics<CR>
nnoremap <silent><leader>co :<C-u>CocList outline<CR>
nnoremap <silent><leader>cr :<C-u>CocListResume<CR>
" coc-clangd
nmap <silent><leader>s :CocCommand clangd.switchSourceHeader<CR>
" coc-explorer
nmap <silent><leader>e :CocCommand explorer --sources file+<CR>
" coc-snippets => expand snippet
imap <C-l> <Plug>(coc-snippets-expand)

" Dispatch:
nnoremap <localleader>c :Dispatch! **oe-workdir/**temp/run.do_compile<CR>
nnoremap <localleader>T :Dispatch! **oe-workdir/**temp/run.do_test<CR>
nnoremap <localleader>t :Dispatch  **oe-workdir/**temp/run.do_test<CR>

" EasyAlign:
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Fzf:
nnoremap <silent><C-p> :Files<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent>_     :Marks<CR>
nnoremap <silent>,     :Buffers<CR>

" Git:
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gis :Gstatus<CR>

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
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
exe 'hi LineNr guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
exe 'hi SignColumn guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00

" Statusline
" ------------
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" }}}}
" Autocommands {{{

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste
" Jump to last known position and center buffer around cursor.
augroup jumplast
  autocmd!
  autocmd BufWinEnter ?* call functions#jumplast()
augroup end
" Remove trailing whitespace on save
augroup trailingwhitespace
  autocmd!
  autocmd BufWritePre * call functions#stripTrailingWhitespace()
augroup end
" File type settings
augroup filetypesettings
  autocmd!
  autocmd Filetype gitcommit,markdown setl spell        tw=72
  autocmd FileType c,cpp              setl shiftwidth=4 tabstop=4 commentstring=//\ %s
  autocmd FileType java               setl shiftwidth=2 tabstop=2 commentstring=//\ %s
  autocmd FileType vim                setl shiftwidth=2 tabstop=2
  autocmd FileType sh,zsh             setl shiftwidth=4 tabstop=4
augroup end

" }}}
