" Plugins
" -------

" load plug vim if not installed yet
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

Plug 'junegunn/vim-easy-align'            " Align text in a table form
Plug 'tpope/vim-commentary'               " Comment out lines of code
Plug 'tpope/vim-surround'                 " Surround text with quotes, brackets, etc.
Plug 'matze/vim-move'                     " Move text between lines and columns
Plug 'sickill/vim-pasta'                  " Paste text by predicting indent level
Plug 'svermeulen/vim-subversive'          " Replace and substitute text
Plug 'tpope/vim-fugitive'                 " Git wrapper
Plug 'tpope/vim-repeat'                   " Allow plugins to dot repeat commands
Plug 'rstacruz/vim-closer'                " Autoclose scopes
Plug 'mhinz/vim-sayonara',
    \ { 'on': 'Sayonara' }                " Smart buffer closing
Plug 'Shougo/deoplete.nvim',
    \ { 'do': ':UpdateRemotePlugins' }    " Code completion engine
if executable('clang')
    Plug 'zchee/deoplete-clang'           " Code completion for clang languages
    Plug 'rhysd/vim-clang-format'         " Code formatter for clang languages
endif
Plug 'Shougo/neosnippet.vim'              " Code snippets functionality
Plug 'Shougo/neosnippet-snippets'         " Pre-made, community driven snippets
Plug 'scrooloose/nerdtree'                " File browser
Plug 'junegunn/fzf',
    \ { 'dir': fzfsourcedir,
    \   'do': './install --all --xdg'}    " Fuzzy searching
Plug 'junegunn/fzf.vim'
if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator' " Easy pane navigation with vim
endif
Plug 'mhinz/vim-startify'                 " Appealing and functional startup screen
Plug 'chriskempson/base16-vim'            " Base16 colorscheme
Plug 'daviesjamie/vim-base16-lightline'
Plug 'itchyny/lightline.vim'              " Status bar
Plug 'ap/vim-buftabline'                  " Buffer status bar
Plug 'myusuf3/numbers.vim'                " Smart relative line numbering
Plug 'vim-syntastic/syntastic'            " Syntax checker
Plug 'sheerun/vim-polyglot'               " Language plugins
Plug 'kergoth/vim-bitbake'                " Bitbake language syntax highlighting

call plug#end()
