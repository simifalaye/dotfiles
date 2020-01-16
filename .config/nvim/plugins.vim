" Plugins
" -------

" load plug vim if not installed yet
call functions#getVimPlug(vimautoloaddir)
call plug#begin(vimplugdir)

" Text manipulation
" -----------------
Plug 'junegunn/vim-easy-align'
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-abolish'
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
  command! -bang -nargs=* -complete=dir SmartFiles call functions#smartFiles(<q-args>)
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
  let g:polyglot_disabled = ['markdown']
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  let g:UltiSnipsSnippetsDir              = vimhomedir . '/UltiSnips'
  let g:UltiSnipsExpandTrigger            = "<cr>"
  let g:UltiSnipsListSnippets             = "<c-l>"
  let g:UltiSnipsJumpForwardTrigger       = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger      = "<c-k>"
Plug 'ycm-core/YouCompleteMe', {'do': function('functions#buildYCM')}
  let g:ycm_global_ycm_extra_conf = '~/.config/nvim/.ycm_extra_conf.py'
  let g:ycm_confirm_extra_conf=0
  let g:ycm_clangd_uses_ycmd_caching = 0
  let g:ycm_clangd_args = ['-log=verbose', '-pretty', '-query-driver=/home/**/usr/bin/arm*linux-gnueabi-g++']
  let g:ycm_show_diagnostics_ui = 0
  let g:ycm_max_num_candidates = 30
  nnoremap <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
  nnoremap gr :YcmCompleter GoToReferences<CR>
  nnoremap gi :YcmCompleter GoToImplementation<CR>
  nnoremap gd :YcmCompleter GetDoc<CR>

call plug#end()
" Call setup functions
call helpers#lightline#floating()
