"-- Ack vim --"
" Use Ag for searches
if executable('ag')
    let g:ackprg = 'ag --vimgrep --smart-case'
endif

"-- Syntastic --"
autocmd BufNewFile,BufRead *.c,*.h call SyntasticSETUP()
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting=1
let g:syntastic_enable_balloons=1
let g:syntastic_stl_format = '[%E{Err:%e Line:%fe}%B{, }%W{Warn:%w Line:%fw}]'
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0

"-- nerdtree --"
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks=1
" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | execute "only" | endif
" Open NERDTree when starting vim up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") |
    \ exe 'NERDTree' argv()[0] | wincmd p | ene | endif

"-- vim-commentary --"
" Set commentstring for file types
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType c,cpp,java setlocal commentstring=//\ %s
autocmd FileType conf,bitbake setlocal commentstring=#\ %s

"-- vim-easyclip --"
set clipboard=unnamedplus
let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
let g:EasyClipAutoFormat = 1
let g:EasyClipUseSubstituteDefaults = 1

"-- delimitMate --"
" Match block delimiters for Ruby and C-like languages
let b:delimitMate_expand_cr = 1
execute "inoremap {<CR> {<CR>}<ESC>O"

"-- fzf.vim --"
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }
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

"-- UltiSnips --"
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<S-tab>"
let g:UltiSnipsJumpForwardTrigger="<S-tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsSnippetsDir=ultisnipsdirsave

"-- buftabline --"
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

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
      \     'ntree': 'MyLightLinePercent',
      \     'lineinfo': 'MyLightLineLineInfo',
      \     'fugitive': 'LightlineFugitive',
      \   },
      \ }

"-- Buftabline --"
nnoremap <S-l> :bnext<CR>
nnoremap <S-H> :bprev<CR>
