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
colorscheme base16-default-dark
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
exe 'hi LineNr guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
exe 'hi SignColumn guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
