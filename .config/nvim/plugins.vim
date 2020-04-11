" Plugins
" =========
" load plug vim if not installed yet
call helpers#utils#getVimPlug(g:vimautoloaddir)
call plug#begin(g:vimplugdir)

" Text manipulation
" -------------------
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Integration Utilities
" -----------------------
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
" Files / Buffers
" -----------------
Plug 'junegunn/fzf', {'dir': g:fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
" UI
" ----
Plug 'chriskempson/base16-vim' | Plug 'Yggdroot/indentLine'
" Code completion / Languages
" -----------------------------
Plug 'derekwyatt/vim-fswitch' | Plug 'vim-scripts/DoxygenToolkit.vim'
  map <F5> :FSHere<CR>
Plug 'kergoth/vim-bitbake' | Plug 'wgwoods/vim-systemd-syntax'
Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled     = 1
  let g:vim_markdown_auto_insert_bullets  = 0
  let g:vim_markdown_new_list_item_indent = 0
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  let g:UltiSnipsSnippetsDir         = g:vimhomedir . '/UltiSnips'
  let g:UltiSnipsExpandTrigger       = "<c-j>"
  let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-snippets',
        \ 'coc-word',
        \]
call plug#end()

" Call setup functions
call helpers#fzf#setup()
call helpers#startify#setup()
