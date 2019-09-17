"-- Colors --"
" Fixes bckgrd color issues (especially on windows)
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

" Set theme
colorscheme base16-default-dark
set background=dark
set laststatus=2
