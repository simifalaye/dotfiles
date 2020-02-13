" Misc Functions
" ===============

""
" Gets vim-plug from github
"
" @param {string} dir: directory to put vim-plug in
""
function! functions#getVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

""
" Zoom into a pane, making it full screen (in a tab)
" Triggering the plugin again from the zoomed in tab brings it back
" to its original pane location
""
function functions#zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, ' . bufnr('') . ') >= 0')) > 1
    tabclose
  endif
endfunction

""
" Toggle nerd tree
""
function! functions#nerdTreeToggleFind()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    NERDTreeClose
  elseif filereadable(expand('%'))
    NERDTreeFind
  else
    NERDTreeToggle
  endif
endfunction

""
" Don't close window, when deleting a buffer
""
function! functions#bufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")
  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif
  if bufnr("%") == l:currentBufNum
    new
  endif
  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction
