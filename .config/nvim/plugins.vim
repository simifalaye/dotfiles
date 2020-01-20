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
Plug 'wellle/targets.vim'

" Integration Utilities
" ---------------------
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive', { 'on': [ 'Gstatus', 'Gblame', 'Gdiff' ] }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'

" Files / Buffers
" ---------------
Plug 'airblade/vim-rooter'
  let g:rooter_patterns = ['Rakefile', '.git', '.git/']
Plug 'junegunn/fzf', {'dir': fzfsourcedir,'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '~40%' }
  let g:fzf_buffers_jump = v:true
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
Plug 'moll/vim-bbye', { 'on': ['Bdelete', 'Bclose'] }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  " Close vim if last window
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  let g:NERDTreeWinPos              = "left"
  let g:NERDTreeMinimalUI           = v:true
  let g:NERDTreeQuitOnOpen          = v:true
  let g:NERDTreeShowHidden          = v:true
  let g:NERDTreeShowBookmarks       = v:true
  let g:NERDTreeHighlightCursorline = v:true
  let g:NERDTreeDirArrowExpandable  = '+'
  let g:NERDTreeDirArrowCollapsible = '-'

" UI
" ---
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
  let g:lightline = {
    \   'colorscheme': 'wombat',
    \   'active': {
    \     'left': [[ 'mode', 'paste' ], [ 'fugitive', 'filename']]
    \   },
    \   'component_function': {
    \     'modified': 'helpers#lightline#fileModified',
    \     'readonly': 'helpers#lightline#readOnly',
    \     'filename': 'helpers#lightline#fileName',
    \     'fileformat': 'helpers#lightline#fileFormat',
    \     'filetype': 'helpers#lightline#fileType',
    \     'fileencoding': 'helpers#lightline#fileEnc',
    \     'mode': 'helpers#lightline#mode',
    \     'fugitive': 'helpers#lightline#fugitive',
    \   },
    \   'subseparator': { 'left': '>', 'right': '' }
    \ }
Plug 'mhinz/vim-startify'

" Code completion / Languages
" ---------------------------
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  let g:UltiSnipsSnippetsDir              = vimhomedir . '/UltiSnips'
  let g:UltiSnipsExpandTrigger            = "<c-j>"
  let g:UltiSnipsListSnippets             = "<c-l>"
  let g:UltiSnipsJumpForwardTrigger       = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger      = "<c-k>"
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
  let g:lsp_highlight_references_enabled = 1
  " Autoclose preview window when completion is done
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

call plug#end()

" Call setup functions
call helpers#lightline#floating()
call helpers#asyncomplete#setupSources()
call helpers#lsp#setupSources()
