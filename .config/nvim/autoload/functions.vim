" =================================
" Miscellaneous Functions
" =================================

""
" Check if backspace is hit
""
fun! functions#checkBackspace()
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun

""
" Gets vim-plug from github
"
" @param {string} dir: directory to put vim-plug in
""
fun! functions#getVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfun

""
" Zoom into a pane, making it full screen (in a tab) Triggering the plugin
" again from the zoomed in tab brings it back to its original pane location
""
fun functions#zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
        \ 'index(v:val, ' . bufnr('') . ') >= 0')) > 1
    tabclose
  endif
endfun

""
" Jump to last known position and center buffer around cursor.
""
fun! functions#jumplast() abort
  if empty(&buftype) && index(['diff', 'gitcommit'], &filetype, 0, v:true) == -1
    if line("'\"") >= 1 && line("'\"") <= line('$')
      execute 'normal! g`"zz'
    endif
  endif
endfun

""
" Remove trailing whitespace
""
fun! functions#stripTrailingWhitespace() abort
  " Don't strip on these filetypes
  if &ft =~ 'ruby\|javascript\|perl\|gitsendemail\|markdown'
    return
  endif
  %s/\s\+$//e
endfun

""
" Don't close window, when deleting a buffer
""
fun! functions#bufcloseCloseIt()
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
endfun

""
" Put list into quickfix
"
" @param {string} lines: lines to put
""
fun! functions#build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfun

""
" Show documentation for coc if not in a vim buffer
""
fun! functions#cocShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

""
" Run the yocto compile and test binaries for quickly verifying code
"
" @param {bool} silent: Dispatch in the background instead of foreground
" @param {bool:def = false} dotest: Dispatch the test suite
""
fun! functions#yoctoDispatch(silent, ...)
  let l:build = finddir('oe-workdir', expand('%:p:h').';')
  if (l:build == "")
    echo "Can't find local build directory oe-workdir"
    return
  endif

  let l:dotest = get(a:, 1, v:false)
  let l:bin = l:dotest == v:true ? "run.do_test" : "run.do_compile"
  let l:sil = a:silent == v:true ? "!" : ""

  " Run dispatch
  execute 'Dispatch' . l:sil . ' ' . l:build . '/**temp/' . l:bin
endfun
