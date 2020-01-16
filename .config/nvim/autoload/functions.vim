function! functions#getVimPlug(dir)
  " Gets vim-plug from github
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

function! functions#checkBackspace()
  " Check if backspace is hit
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~ '\s'
endfunction

function! functions#smartFiles(...)
  " Fzf call Files or GFiles based on if in git dir
  silent! !git rev-parse --is-inside-work-tree
  if v:shell_error == 0
    return call("fzf#vim#gitfiles", a:000)
  else
    return call("fzf#vim#files", a:000)
  endif
endfunction

function functions#zoom()
  " Zoom into a pane, making it full screen (in a tab)
  " Triggering the plugin again from the zoomed in tab brings it back
  " to its original pane location
    if winnr('$') > 1
        tab split
    elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, ' . bufnr('') . ') >= 0')) > 1
        tabclose
    endif
endfunction

function! functions#buildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if !executable('cmake') || !executable('python') ||
        \ !executable('make') || !executable('cc') || !executable('c++')
    return
  endif

  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    let l:cmd = './install.py'
    if executable('clang')
      let l:cmd .= ' --clangd-completer --clang-completer'
      let l:cmd = '(export CC=$(which clang); export CXX=$(which clang++); ' . l:cmd . ')'
    endif
    execute "!" . a:command
  endif
endfunction

function! functions#nerdTreeToggleFind()
  " Toggle nerd tree
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
      NERDTreeClose
  elseif filereadable(expand('%'))
      NERDTreeFind
  else
      NERDTreeToggle
  endif
endfunction
