" Color support
" -------------
" Fixes bckgrd color issues (wsl support)
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif
" Enable true color support
if (has("termguicolors"))
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set t_Co=256

" Set theme
" ---------
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Set status line display
" -------------------------
" IMPORTANT: Variables require a base16 colorscheme

exe 'hi User1 guifg=#' . g:base16_gui04 . ' guibg=#' . g:base16_gui00
exe 'hi User2 guifg=#' . g:base16_gui01 . ' guibg=#' . g:base16_gui09
exe 'hi User3 guifg=#' . g:base16_gui01 . ' guibg=#' . g:base16_gui0A
exe 'hi User4 guifg=#' . g:base16_gui03 . ' guibg=#' . g:base16_gui01
exe 'hi User5 guifg=#' . g:base16_gui01 . ' guibg=#' . g:base16_gui03
exe 'hi LineNr guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
exe 'hi SignColumn guifg=#' . g:base16_gui02 . ' guibg=#' . g:base16_gui00
set laststatus=2
set statusline=
set statusline+=%2*\ %{helpers#status#mode(mode())}              " Current mode
set statusline+=%3*\ %{helpers#status#gitBranch()}\              " Git Branch name
set statusline+=%1*\ %4*\ %<%t\ %{helpers#status#readOnly()}\ %m " File
set statusline+=%1*\ %{coc#status()}                             " Coc status
set statusline+=%*
set statusline+=%1*\ %=                                          " Space
set statusline+=%1*\ %y\                                         " FileType
set statusline+=%5*\ %l/%L,\ %c\                                 " Rownumber/total (%)
