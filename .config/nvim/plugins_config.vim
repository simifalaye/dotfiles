" NerdTree
" --------

" Close vim if last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinPos = "left"
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 'p', 'stay': 1}, 'dir': {}}
let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible

" Code Completion & Snippets
" --------------------------

" UltiSnips
let g:UltiSnipsSnippetsDir = vimhomedir . '/UltiSnips'
let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
let g:UltiSnipsListSnippets = '<c-l>'
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0
" Coc.nvim
set shortmess+=c
set signcolumn=yes
" Default is 4000, lower it for better performance
set updatetime=300
" \ 'coc-java',
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-snippets',
      \]

" Text manipulation plugins
" ------------------------

" Disable polygot for some langs
let g:polyglot_disabled = ['markdown']
" Autoformat vim yoink paste
let g:yoinkAutoFormatPaste = 1
let g:yoinkSavePersistently = 1
let g:yoinkIncludeDeleteOperations = 1

" Fzf vim
" --------

" Default fzf layout
let g:fzf_layout = { 'down': '~40%' }
" Jump to window if buffer is already open
let g:fzf_buffers_jump = 1
" New command 'SmartFiles' based on git dir
command! -bang -nargs=* -complete=dir SmartFiles call SmartFilesFunc(<q-args>)
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

" Statusline
" -----------

let g:lightline = {
  \   'colorscheme': 'jellybeans',
  \   'active': {
  \     'left': [[ 'mode', 'paste' ], [ 'fugitive', 'filename']]
  \   },
  \   'component_function': {
  \     'modified': 'LightlineModified',
  \     'readonly': 'LightlineReadonly',
  \     'filename': 'LightlineFilename',
  \     'fileformat': 'LightlineFileformat',
  \     'filetype': 'LightlineFiletype',
  \     'fileencoding': 'LightlineFileencoding',
  \     'mode': 'LightlineMode',
  \     'ntree': 'MyLightLinePercent',
  \     'lineinfo': 'MyLightLineLineInfo',
  \     'fugitive': 'LightlineFugitive',
  \   },
  \   'separator': { 'left': '▓▒░', 'right': '░▒▓' },
  \   'subseparator': { 'left': '>', 'right': '' }
  \ }
