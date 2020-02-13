" Plugins
" -------

" load plug vim if not installed yet
call functions#getVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
" -----------------
Plug 'junegunn/vim-easy-align'
Plug 'svermeulen/vim-subversive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'

" Integration Utilities
" ---------------------
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
    let g:prosession_dir = '~/.config/nvim/session/'
    let g:prosession_tmux_title = v:true
    let g:prosession_tmux_title_format = "vim:@@@"

" Files / Buffers
" ---------------
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
  let g:fzf_layout       = { 'down': '~40%' }
  let g:fzf_buffers_jump = v:true
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin'
  " Close vim if last window
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  let g:NERDTreeMinimalUI           = v:true
  let g:NERDTreeQuitOnOpen          = v:true
  let g:NERDTreeShowBookmarks       = v:true
  let g:NERDTreeAutoDeleteBuffer    = v:true

" UI
" ---
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'

" Code completion / Languages
" ---------------------------
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  let g:UltiSnipsSnippetsDir              = vimhomedir . '/UltiSnips'
  let g:UltiSnipsExpandTrigger            = "<c-j>"
  let g:UltiSnipsListSnippets             = "<c-l>"
  let g:UltiSnipsJumpForwardTrigger       = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger      = "<c-k>"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  set shortmess+=c
  set signcolumn=no
  " Default is 4000, lower it for better performance
  set updatetime=300
  let g:coc_global_extensions = [
              \ 'coc-calc',
              \ 'coc-json',
              \ 'coc-snippets',
              \ 'coc-yank',
              \]

call plug#end()

" Call setup functions
call helpers#lightline#setup()
call helpers#fzf#setup()
