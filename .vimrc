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

" Use leader to specify extra keybinding
let mapleader = " "
" Set directories
let vimplugdir='~/.vim/plugged'
let vimautoloaddir='~/.vim/autoload'
" Set tags file locations
set tags=./tags,./.git/tags;

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" Use ; for commands., do not have to hold shift to do commands
nnoremap ; :
nnoremap , :

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Reload vim configuration file
nnoremap <Leader>rn :source $MYVIMRC<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM navigation (tabs, windows, buffers)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map Ctrl-/ to ? (backwards search)
" map <c-/> ?

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Shift + Direction to change tabs
noremap <S-l> gt
noremap <S-h> gT

" Control + Direction to change panes
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

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

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save file with Leader + w
" Save and quit -> Leader + s
nnoremap <leader>w :w<cr>
nnoremap <leader>s :wq<cr>

"Map Ctrl + S to save in any mode
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>

" Quit file with Leader + q
" Quit without saving
" Quit all tabs (must be in normal)
nnoremap <leader>q :q<cr>
nnoremap <leader>x :q!<cr>
nnoremap <leader>X :tabdo q<cr>

" Reload files changed outside vim
set autoread

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Turn persistent undo on. Means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

" :W sudo saves the file
" (useful for handling the permission-denied error)
if !exists(':W')
    command W w !sudo tee % > /dev/null
endif

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    silent !mkdir ~/.vim/undodir > /dev/null 2>&1
    set undodir=~/.vim/undodir
    set undofile
catch
endtry


" --------------------------------------------------------------------------------------------------
" Plugins
" --------------------------------------------------------------------------------------------------

"load plug vim if we do not have it yet
if empty(glob(vimautoloaddir . '/plug.vim'))
  " TODO: else?
  if executable('curl')
    execute 'silent !curl -fLo ' . vimautoloaddir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Run your favorite search tool from Vim, with an enhanced results list.
Plug 'mileszs/ack.vim'
" Syntax checker
Plug 'vim-syntastic/syntastic'
" UI colors and look
Plug 'altercation/vim-colors-solarized'
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
" Very well be the best Git wrapper of all time
Plug 'tpope/vim-fugitive'
" Repeat.vim remaps . in a way that plugins can tap into it
Plug 'tpope/vim-repeat'
" The NERDTree is a file system explorer for the Vim editor
Plug 'scrooloose/nerdtree'
" Lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'
" Comment stuff out
Plug 'tpope/vim-commentary'
" EasyClip is a plugin for Vim which contains a collection of clipboard related functionality
Plug 'svermeulen/vim-easyclip'
" A Vim plugin which shows a git diff in the 'gutter' (sign column)
Plug 'airblade/vim-gitgutter'
" A code-completion engine for Vim
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" Auto-close scopes
Plug 'Raimondi/delimitMate'
" Nice browser for CTags
Plug 'majutsushi/tagbar'
" Man browser for Vim
Plug 'bruno-/vim-man'
" Puts filetype glyphs in explorer plugins such as NERDTree
Plug 'ryanoasis/vim-devicons'
" Tmux Focus Events
Plug 'tmux-plugins/vim-tmux-focus-events'

" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets up the standard include directories based on your current working directory
if !exists('*SyntasticSETUP')
    function SyntasticSETUP()
        let makedir = fnamemodify(findfile("Makefile", ",;"), ":.:h")
        let include_dirs = split(substitute(substitute(system("cd " . shellescape(makedir) . \
         " ; make debug_print | grep \'INC_DIRS:\'"), "INC_DIRS:", "", "g"), " *-I", " ", "g"))
        let include_dirs = filter(include_dirs, 'v:val =~ "^\/"')
        call add(include_dirs, makedir)
        call add(include_dirs, makedir . "/../include")
        let g:syntastic_c_include_dirs = include_dirs
        let b:syntastic_c_cflags = ' -DLINUXPC -DDEV_PC -D_GNU_SOURCE -Wall -Werror -Wextra'
    endfunction
endif

autocmd BufNewFile,BufRead *.c,*.h call SyntasticSETUP()
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting=1
let g:syntastic_enable_balloons=1
let g:syntastic_stl_format = '[%E{Err:%e Line:%fe}%B{, }%W{Warn:%w Line:%fw}]'
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NerdTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Theming: solarized, airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:solarized_termcolors=16
let g:colarized_termtrans = 1
let g:solarized_termcolors=256
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized
set background=dark

let g:airline_powerline_fonts = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git gutter (Git diff)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim easy clip
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set clipboard=unnamedplus
let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipAutoFormat = 1
let g:EasyClipUseSubstituteDefaults = 1

vnoremap <C-c> y
imap <C-v> <plug>EasyClipInsertModePaste

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim easy align
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Ag for searches
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" Map leader + g to ack
nnoremap <Leader>g :Ack!<Space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim.commentary
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set commentstring for file types
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType c,cpp,java setlocal commentstring=//\ %s
autocmd FileType conf,bitbake setlocal commentstring=#\ %s

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>tt :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => DelimMate
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Match block delimiters for Ruby and C-like languages
let b:delimitMate_expand_cr = 1
execute "inoremap {<CR> {<CR>}<ESC>O"

" --------------------------------------------------------------------------------------------------
" File Type
" --------------------------------------------------------------------------------------------------


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Bitbake
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This sets up the syntax highlighting for BitBake files, like .bb, .bbclass and .inc
if &compatible || version < 600
    finish
endif
" .bb, .bbappend and .bbclass
au BufNewFile,BufRead *.{bb,bbappend,bbclass}	set filetype=bitbake
" .inc
au BufNewFile,BufRead *.inc		set filetype=bitbake
" .conf
au BufNewFile,BufRead *.conf
    \ if (match(expand("%:p:h"), "conf") > 0) |
    \     set filetype=bitbake |
    \ endif
