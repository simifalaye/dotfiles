" Plugins
" -------

" load plug vim if not installed yet
call helpers#utils#getVimPlug(g:vimautoloaddir)
call plug#begin(g:vimplugdir)

" Text manipulation
" -----------------
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Integration Utilities
" ---------------------
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'

" Files / Buffers
" ---------------
Plug 'junegunn/fzf', {'dir': g:fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim', { 'on': ['Fern'] }

" UI
" ---
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'

" Code completion / Languages
" ---------------------------
Plug 'kergoth/vim-bitbake'
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
  let g:UltiSnipsListSnippets        = "<c-l>"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  set shortmess+=c
  set signcolumn=no
  " Default is 4000, lower it for better performance
  set updatetime=300
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-lua',
        \ 'coc-snippets',
        \]
call plug#end()

" Call setup functions
call helpers#fzf#setup()
call helpers#startify#setup()
