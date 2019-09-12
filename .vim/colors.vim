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
    set t_Co=256
endif

" Set theme
colorscheme base16-default-dark
set background=dark
set laststatus=2
