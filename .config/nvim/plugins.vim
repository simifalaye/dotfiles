"-- load plug vim if not installed yet --"
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

"-- Syntax checker --"
Plug 'vim-syntastic/syntastic'

"-- Text manipulation --"
Plug 'svermeulen/vim-easyclip'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'matze/vim-move'

"-- Utilities --"
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

"-- A code-completion engine and snippets --"
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
if executable('clang')
    Plug 'zchee/deoplete-clang'
endif
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

"-- Files --"
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
if executable('fzf')
    Plug 'junegunn/fzf', { 'dir': fzfsourcedir, 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
endif

"-- Tmux --"
if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
endif

" -- UI -- "
Plug 'mhinz/vim-startify'
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'

call plug#end()
