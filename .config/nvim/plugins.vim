" Plugins
" -------

" load plug vim if not installed yet
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'matze/vim-move'
Plug 'sickill/vim-pasta'
Plug 'svermeulen/vim-subversive'
Plug 'rstacruz/vim-closer'

" Integration Utilities
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
if executable('tmux')
Plug 'christoomey/vim-tmux-navigator'
endif

" Files / Buffers
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-sayonara',{ 'on': 'Sayonara' }
Plug 'junegunn/fzf',
    \ {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'

" UI
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'

" Code completion / Language specific
Plug 'vim-syntastic/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'kergoth/vim-bitbake'
Plug 'Shougo/deoplete.nvim',{'do': ':UpdateRemotePlugins'}
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
if executable('clang')
Plug 'zchee/deoplete-clang'
endif

call plug#end()
