" Plugins
" -------

" load plug vim if not installed yet
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
Plug 'junegunn/vim-easy-align'
Plug 'spf13/vim-autoclose'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-yoink'
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
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'moll/vim-bbye'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }

" UI
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'

" Code completion / Languages
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-pyclang'
Plug 'ncm2/ncm2-ultisnips'
Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
Plug 'roxma/nvim-yarp'
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

call plug#end()
