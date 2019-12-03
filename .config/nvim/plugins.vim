" Plugins
" -------

" load plug vim if not installed yet
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
Plug 'cohama/lexima.vim'
Plug 'junegunn/vim-easy-align'
Plug 'svermeulen/vim-subversive'
Plug 'svermeulen/vim-yoink'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

" Integration Utilities
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

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
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
