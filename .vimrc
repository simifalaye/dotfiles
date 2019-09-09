"  ---------------------------------------------------------------------------
"  " Vecima standard vim setup
"  "
"  "
"  "
"  ---------------------------------------------------------------------------
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
"  ---------------------------------------------------------------------------

" ==================== Global Settings ==================== "

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

" ==================== General Mappings ==================== "
" Use ; for commands., do not have to hold shift to do commands
nnoremap ; :
nnoremap , :

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Reload vim configuration file
nnoremap <Leader>rn :source $MYVIMRC<CR>

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Shift + Direction to change tabs
noremap <S-l> gt
noremap <S-h> gT

" Control + Direction to change panes
nmap <C-down> <C-W>j
nmap <C-up> <C-W>k
nmap <C-left> <C-W>h
nmap <C-right> <C-W>l

" Move lines up and down with shift + dir
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" Save file with ctrl + s
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
" Save and quit -> Leader + s
noremap <silent> <C-A>          :wq<CR>
vnoremap <silent> <C-A>         <C-C>:wq<CR>
inoremap <silent> <C-A>         <C-O>:wq<CR>

" Quit file with Leader + q
" Quit without saving
" Quit all tabs (must be in normal)
nnoremap <leader>q :q<cr>
nnoremap <leader>x :q!<cr>
nnoremap <leader>X :tabdo q<cr>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" fast scrolling
nmap <C-k> 10k
nmap <C-l> 3e
nmap <C-j> 10j
nmap <C-h> 3b

" ==================== Files, backups and undo ==================== "
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

" ==================== Helper Functions ==================== "
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Install ycm on system
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

" Sets up the standard include directories based on your current working directory
function! SyntasticSETUP()
    let makedir = fnamemodify(findfile("Makefile", ",;"), ":.:h")
    let include_dirs = split(substitute(substitute(system("cd " . shellescape(makedir) . " ; make debug_print | grep \'INC_DIRS:\'"), "INC_DIRS:", "", "g"), " *-I", " ", "g"))
    let include_dirs = filter(include_dirs, 'v:val =~ "^\/"')
    call add(include_dirs, makedir)
    call add(include_dirs, makedir . "/../include")
    let g:syntastic_c_include_dirs = include_dirs
    let b:syntastic_c_cflags = ' -DLINUXPC -DDEV_PC -D_GNU_SOURCE -Wall -Werror -Wextra'
endfunction

" Gets vim-plug
function! GetVimPlug()
    if executable('curl')
        execute 'silent !curl -fLo ' . vimautoloaddir . '/plug.vim --create-dirs ' .
              \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endfunction

" ==================== Plugins ==================== "
"load plug vim if not installed yet
if empty(glob(vimautoloaddir . '/plug.vim'))
    GetVimPlug()
endif

call plug#begin(vimplugdir)

" ========== Run your favorite search tool from Vim, with an enhanced results list. {{{
    Plug 'mileszs/ack.vim'

    " Use Ag for searches
    if executable('ag')
      let g:ackprg = 'ag --vimgrep --smart-case'
    endif

    " Map leader + g to ack
    nnoremap <Leader>g :Ack!<Space>
" }}}

" ========== Syntax checker {{{
    Plug 'vim-syntastic/syntastic'

    autocmd BufNewFile,BufRead *.c,*.h call SyntasticSETUP()
    let g:syntastic_enable_signs=1
    let g:syntastic_enable_highlighting=1
    let g:syntastic_enable_balloons=1
    let g:syntastic_stl_format = '[%E{Err:%e Line:%fe}%B{, }%W{Warn:%w Line:%fw}]'
    let g:syntastic_c_remove_include_errors = 1
    let g:syntastic_check_on_open=0
    let g:syntastic_check_on_wq=0
" }}}

" ========== Align lines into columns {{{
    Plug 'junegunn/vim-easy-align'

    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
" }}}

" ========== Very well be the best Git wrapper of all time {{{
    Plug 'tpope/vim-fugitive'
" }}}

" ========== Repeat.vim remaps . in a way that plugins can tap into it {{{
    Plug 'tpope/vim-repeat'
" }}}

" ========== A file system explorer for the Vim editor {{{
    Plug 'scrooloose/nerdtree'

    let g:NERDTreeDirArrowExpandable = '+'
    let g:NERDTreeDirArrowCollapsible = '-'
    let NERDTreeMinimalUI=0
    let NERDTreeShowBookmarks=1

    " Bind \n to toggle NERDTree
    map <leader>nn :NERDTreeToggle<CR>
    map <leader>nf :NERDTreeFind<cr>

    " Open a NERDTree automatically when vim starts up if no files were specified
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | execute "only" | endif

    " Open NERDTree when starting vim up on opening a directory
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") |
        \ exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" }}}

" ========== Comment stuff out {{{
    Plug 'tpope/vim-commentary'

    " Set commentstring for file types
    autocmd FileType vim setlocal commentstring=\"\ %s
    autocmd FileType c,cpp,java setlocal commentstring=//\ %s
    autocmd FileType conf,bitbake setlocal commentstring=#\ %s
" }}}

" ========== Easier copy and paste {{{
    Plug 'svermeulen/vim-easyclip'

    set clipboard=unnamed
    let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
    let g:EasyClipAutoFormat = 1
    let g:EasyClipUseSubstituteDefaults = 1

    " Remap copy
    vmap <C-c> y
    " Remap Paste
    imap <C-v> <plug>EasyClipInsertModePaste
    vmap <C-v> s
    " Remap Cut
    vmap <C-x> m
" }}}

" ========== A code-completion engine for Vim {{{
    if executable('cmake') && executable('python') && executable('make') &&
     \ executable('cc') && executable('c++')
        Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
    endif
" }}}

" ========== Auto-close scopes {{{
    Plug 'Raimondi/delimitMate'
    Plug 'tpope/vim-endwise'

    " Match block delimiters for Ruby and C-like languages
    let b:delimitMate_expand_cr = 1
    execute "inoremap {<CR> {<CR>}<ESC>O"
" }}}

" ========== Show indent level {{{
    Plug 'Yggdroot/indentLine'
" }}}

" ========== Multiple cursors {{{
    Plug 'terryma/vim-multiple-cursors'
" }}}

" ========== Collection of language packs (syntax, indent, ftplugin) {{{
    Plug 'sheerun/vim-polyglot'
" }}}

" ========== Fuzzy file finder {{{
    " PlugInstall/Update will clone fzf in fzfsourcedir and run the install script
    Plug 'junegunn/fzf', { 'dir': fzfsourcedir, 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Default fzf layout
    " - down / up / left / right
    let g:fzf_layout = { 'down': '~40%' }
    nnoremap <silent><c-f> :GFiles<cr>
    nnoremap <silent><c-e> :FZF<cr>
" }}}

" ========== Ultimate snippets {{{
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    " Trigger configuration. Do not use <tab> if you use
    " https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger='<c-l>'
    let g:UltiSnipsJumpForwardTrigger='<c-f>'
    let g:UltiSnipsJumpBackwardTrigger='<c-b>'

    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="horizontal"
    " Snip file save dir
    let g:UltiSnipsSnippetsDir=ultisnipsdirsave
" }}}

" ========== Theming (Colorscheme, airline, icons for Nerdtree) {{{
    Plug 'morhetz/gruvbox'
    Plug 'chriskempson/base16-vim'
    Plug 'itchyny/lightline.vim'
    Plug 'ryanoasis/vim-devicons'

    " Set lightline theme
    let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ }
" }}}

call plug#end()

" ==================== User Interface ==================== "
" Display line numbers
set number

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

" Fixes bckgrd color issues (especially on windows)
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

" Enable true color support
if (has("termguicolors"))
    set termguicolors
    set t_Co=256
endif

" Set theme
" colorscheme gruvbox
colorscheme base16-default-dark
set background=dark
set laststatus=2
