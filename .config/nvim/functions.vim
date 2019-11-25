" Gets vim-plug
function! GetVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

" Refresh nerdtree
function! NERDTreeRefresh()
  if &filetype == "nerdtree"
      silent exe substitute(mapcheck("R"), "<CR>", "", "")
  endif
endfunction

" Check if backspace is hit
function! CheckBackspace() abort
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~ '\s'
endfunction
