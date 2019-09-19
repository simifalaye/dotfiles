"-- Syntastic --"
autocmd BufNewFile,BufRead *.c,*.h call SyntasticSETUP()
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting=1
let g:syntastic_enable_balloons=1
let g:syntastic_stl_format = '[%E{Err:%e Line:%fe}%B{, }%W{Warn:%w Line:%fw}]'
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0

"-- Nerdtree --"
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStHatusline = " "
let g:NERDTreeWinPos = "right"

"-- DeopleteMe --"
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-6.0/lib/libclang.so.1"
let g:deoplete#sources#clang#clang_header ="/usr/lib/llvm-6.0/lib/clang/"

"-- vim-commentary --"
" Set commentstring for file types
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType c,cpp,java setlocal commentstring=//\ %s
autocmd FileType conf,bitbake setlocal commentstring=#\ %s

"-- vim-easyclip --"
let g:EasyClipUseSubstituteDefaults = 1
let g:EasyClipUsePasteDefaults = 0
let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipAutoFormat = 1

"-- fzf.vim --"
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
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
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

"-- Lightline --"
let g:lightline = {
      \   'colorscheme': 'wombat',
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
      \     'fugitive': 'LightlineFugitive',
      \   },
      \ }

"-- Buftabline --"
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1


