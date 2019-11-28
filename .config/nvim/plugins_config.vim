" NerdTree
" --------

" Close vim if last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStHatusline = " "
let g:NERDTreeWinPos = "left"
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 'p', 'stay': 1}, 'dir': {}}
let g:NERDTreeUpdateOnCursorHold = 0
let g:NERDTreeUpdateOnWrite      = 0

" Code Completion & Snippets
" --------------------------

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()
" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
" suppress the annoying 'match x of y'
set shortmess+=c
" path to directory where libclang.so can be found
let g:ncm2_pyclang#library_path = '/usr/lib/llvm-7/lib/libclang.so.1'
" a list of relative paths for compile_commands.json
let g:ncm2_pyclang#database_path = [
            \ 'compile_commands.json',
            \ 'build/compile_commands.json',
            \ 'oe-workdir/build/compile_commands.json'
            \ ]
" UltiSnips
let g:UltiSnipsSnippetsDir = vimhomedir . '/UltiSnips'
let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
let g:UltiSnipsListSnippets = '<c-l>'
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsRemoveSelectModeMappings = 0

" Text manipulation plugins
" ------------------------

" Set commentstring for file types
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType c,cpp,java setlocal commentstring=//\ %s
autocmd FileType conf,bitbake,cfg setlocal commentstring=#\ %s
" Disable polygot for some langs
let g:polyglot_disabled = ['markdown']
" Autoformat vim yoink paste
let g:yoinkAutoFormatPaste = 1
" Vim autoclose
let g:autoclose_vim_commentmode = 1

" Fzf vim
" --------

" Default fzf layout
let g:fzf_layout = { 'down': '~40%' }
" Jump to window if buffer is already open
let g:fzf_buffers_jump = 1
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
  \     'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename']]
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
