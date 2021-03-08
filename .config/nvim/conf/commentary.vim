" Quickly comment and uncomment lines of code
Plug 'tpope/vim-commentary'

augroup vimcommentary
  au!
  au FileType c,cpp setl commentstring=//\ %s
  au FileType java  setl commentstring=//\ %s
augroup end
