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
if executable('cmake') && executable('python') && executable('make') &&
 \ executable('cc') && executable('c++')
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
endif

"-- Auto-close scopes --"
Plug 'Raimondi/delimitMate'

"-- junegunn: Fuzzy file finder, easy align --"
" PlugInstall/Update will clone fzf in fzfsourcedir and run the install script
Plug 'junegunn/fzf', { 'dir': fzfsourcedir, 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

"-- Ultimate snippets --"
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

""-- Tmux plugins --"
Plug 'christoomey/vim-tmux-navigator'

" -- UI -- "
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'

call plug#end()
