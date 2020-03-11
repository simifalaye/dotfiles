" Plugins
" -------

" load plug vim if not installed yet
call functions#getVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
" -----------------
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Integration Utilities
" ---------------------
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
  let g:prosession_dir = '~/.config/nvim/session/'
  let g:prosession_tmux_title = v:true
  let g:prosession_tmux_title_format = "@@@"

" Files / Buffers
" ---------------
Plug 'airblade/vim-rooter'
  let g:rooter_use_lcd = 1
  let g:rooter_silent_chdir = 1
  let g:rooter_change_directory_for_non_project_files = 'current'
Plug 'junegunn/fzf', {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
  let g:fzf_layout       = { 'down': '~40%' }
  let g:fzf_buffers_jump = v:true
Plug 'lambdalisue/fern.vim'

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
  let g:UltiSnipsSnippetsDir         = vimhomedir . '/UltiSnips'
  let g:UltiSnipsExpandTrigger       = "<c-j>"
  let g:UltiSnipsListSnippets        = "<c-l>"
  let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  set shortmess+=c
  " Default is 4000, lower it for better performance
  set updatetime=300
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  let g:coc_global_extensions = [
        \ 'coc-json',
        \ 'coc-lua',
        \ 'coc-sh',
        \ 'coc-snippets',
        \]

call plug#end()

" Call setup functions
call helpers#fzf#setup()
