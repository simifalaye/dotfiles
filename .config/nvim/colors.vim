" Color support
" -------------
" Fixes bckgrd color issues (windows support)
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
" ---------
set t_Co=256
set background=dark
let base16colorspace=256
if filereadable(expand(vimcolordir))
    exec "source " . vimcolordir
else
    colorscheme base16-default-dark
endif
" Specific to colorscheme
highlight clear LineNr
highlight clear SignColumn
highlight LineNr guifg=#383838
