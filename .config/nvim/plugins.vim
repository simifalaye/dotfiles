"-- load plug vim if not installed yet --"
if empty(glob(vimautoloaddir . '/plug.vim'))
    GetVimPlug()
endif

call plug#begin(vimplugdir)

"-- Syntax checker --"
Plug 'vim-syntastic/syntastic'

"-- Tim Pope: comments, git wrapper, plugin helper --"
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

"-- Easier copy and paste --"
Plug 'svermeulen/vim-easyclip'

"-- A code-completion engine for Vim --"
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

"-- junegunn: Fuzzy file finder, easy align --"
" PlugInstall/Update will clone fzf in fzfsourcedir and run the install script
Plug 'junegunn/fzf', { 'dir': fzfsourcedir, 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

""-- Tmux plugins --"
Plug 'christoomey/vim-tmux-navigator'

" -- UI -- "
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'

call plug#end()
