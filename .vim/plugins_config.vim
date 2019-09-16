"-- Syntastic --"
autocmd BufNewFile,BufRead *.c,*.h call SyntasticSETUP()
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting=1
let g:syntastic_enable_balloons=1
let g:syntastic_stl_format = '[%E{Err:%e Line:%fe}%B{, }%W{Warn:%w Line:%fw}]'
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=0

"-- vim-commentary --"
" Set commentstring for file types
autocmd FileType vim setlocal commentstring=\"\ %s
autocmd FileType c,cpp,java setlocal commentstring=//\ %s
autocmd FileType conf,bitbake setlocal commentstring=#\ %s

"-- vim-easyclip --"
set clipboard=unnamed
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
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"-- UltiSnips --"
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-y>"
let g:UltiSnipsJumpForwardTrigger="<C-b>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"
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
      \     'fugitive': 'LightlineFugitive',
      \   },
      \ }

"-- Buftabline --"
nnoremap <S-l> :bnext<CR>
nnoremap <S-H> :bprev<CR>
