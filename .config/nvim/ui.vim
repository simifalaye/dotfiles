" Color support
" ---------------
" Fixes bckgrd color issues (wsl support)
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif
" Enable true color support
set t_Co=256
if (has("termguicolors"))
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Set theme
" -----------
set background=dark
let base16colorspace=256
colorscheme base16-gruvbox-dark-hard
exe 'hi LineNr guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
exe 'hi SignColumn guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00

" Statusline
" ------------
" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction
function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

let g:lightline = {
            \ 'colorscheme': 'base16',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'fugitive', 'filename', 'readonly', 'modified', 'cocstatus'] ]
            \ },
            \ 'component_function': {
            \   'filename': 'LightlineFilename',
            \   'cocstatus': 'coc#status',
            \   'fugitive': 'LightlineFugitive'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '|', 'right': '|' }
          \ }
