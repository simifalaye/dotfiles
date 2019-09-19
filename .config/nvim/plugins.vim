"-- load plug vim if not installed yet --"
call GetVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

"-- Syntax checker --"
Plug 'vim-syntastic/syntastic'

"-- Text manipulation --"
Plug 'svermeulen/vim-easyclip'
Plug 'junegunn/vim-easy-align'
Plug 'matze/vim-move'

"-- Tim Pope: comments, git wrapper, plugin helper --"
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

"-- A code-completion engine for Vim --"
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
if executable('clang')
    Plug 'zchee/deoplete-clang'
endif
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

"-- junegunn: Fuzzy file finder, easy align --"
" PlugInstall/Update will clone fzf in fzfsourcedir and run the install script
if executable('fzf')
    Plug 'junegunn/fzf', { 'dir': fzfsourcedir, 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
endif

"-- Tmux plugins --"
if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
endif

"-- Utilities --"
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'sheerun/vim-polyglot'

" -- UI -- "
Plug 'mhinz/vim-startify'
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'

call plug#end()
