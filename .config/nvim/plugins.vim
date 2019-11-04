" Plugins
" -------

" load plug vim if not installed yet
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'matze/vim-move'
Plug 'sickill/vim-pasta'
Plug 'svermeulen/vim-subversive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

" Integration Utilities
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

" Files / Buffers
Plug 'junegunn/fzf',
    \ {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-sayonara',{ 'on': 'Sayonara' }
Plug 'scrooloose/nerdtree'

" UI
Plug 'chriskempson/base16-vim'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Code completion / Languages
Plug 'kergoth/vim-bitbake'
Plug 'sheerun/vim-polyglot'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-pyclang'
Plug 'ncm2/ncm2-ultisnips'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()
