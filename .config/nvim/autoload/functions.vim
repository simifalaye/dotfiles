" Gets vim-plug from github
function! functions#getVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

" Check if backspace is hit
function! functions#checkBackspace()
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~ '\s'
endfunction

" Fzf call Files or GFiles based on if in git dir
function! functions#smartFiles(...)
  silent! !git rev-parse --is-inside-work-tree
  if v:shell_error == 0
    return call("fzf#vim#gitfiles", a:000)
  else
    return call("fzf#vim#files", a:000)
  endif
endfunction

" Zoom into a pane, making it full screen (in a tab)
" Triggering the plugin again from the zoomed in tab brings it back
" to its original pane location
function functions#zoom()
    if winnr('$') > 1
        tab split
    elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, ' . bufnr('') . ') >= 0')) > 1
        tabclose
    endif
endfunction
