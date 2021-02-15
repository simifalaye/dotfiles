" Theme and status line
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
  let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
      \ 'left': [ [ 'mode', 'paste' ],
      \           [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
      \ 'filename': 'coc#status',
      \ 'cocstatus': 'LightlineCocStatus'
    \ },
\ }

fun! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfun
