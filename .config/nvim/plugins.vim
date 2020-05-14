" Plugins
" =========
" load plug vim if not installed yet
call helpers#utils#getVimPlug(g:vimautoloaddir)
call plug#begin(g:vimplugdir)

" Text manipulation
" -------------------
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'
" Integration Utilities
" -----------------------
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
" Files / Buffers
" -----------------
Plug 'junegunn/fzf', {'dir': g:fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim' | Plug 'daviesjamie/vim-base16-lightline'
Plug 'preservim/nerdtree'
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  let g:NERDTreeShowHidden = v:true
  let g:NERDTreeMinimalUI  = v:true
  let g:NERDTreeIgnore     = []
  let g:NERDTreeStatusline = ''
" UI
" ----
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'
  let g:indentLine_fileTypeExclude = ['startify', 'markdown']
" Code completion / Languages
" -----------------------------
Plug 'derekwyatt/vim-fswitch' | Plug 'vim-scripts/DoxygenToolkit.vim'
  map <F5> :FSHere<CR>
Plug 'kergoth/vim-bitbake' | Plug 'wgwoods/vim-systemd-syntax'
Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled     = v:true
  let g:vim_markdown_auto_insert_bullets  = v:false
  let g:vim_markdown_new_list_item_indent = v:false
Plug 'sheerun/vim-polyglot'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Call setup functions
call helpers#coc#plugins()
call helpers#fzf#setup()
call helpers#startify#setup()
