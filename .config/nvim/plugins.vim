" Plugins
" -------

" load plug vim if not installed yet
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'sickill/vim-pasta'
Plug 'svermeulen/vim-subversive'
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

" Integration Utilities
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'

" Files / Buffers
Plug 'junegunn/fzf',
    \ {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-sayonara',{ 'on': 'Sayonara' }
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

" UI
Plug 'chriskempson/base16-vim'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code completion / Languages
Plug 'Dinduks/vim-java-get-set'
Plug 'honza/vim-snippets'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-pyclang'
Plug 'ncm2/ncm2-ultisnips'
Plug 'roxma/nvim-yarp'
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips'

call plug#end()
