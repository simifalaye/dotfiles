" =================================
" Miscellaneous Utility Functions
" =================================

""
" Gets vim-plug from github
"
" @param {string} dir: directory to put vim-plug in
""
fun! helpers#utils#getVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfun

""
" Checks if using windows subsystem for linux
"
" @return {bool} true if is WSL
""
fun! helpers#utils#isWSL()
  let uname = substitute(system('uname'),'\n','','')
  if uname == 'Linux'
    let lines = readfile("/proc/version")
    if lines[0] =~ "Microsoft"
      return 1
    endif
  endif
  return 0
endfun

""
" Zoom into a pane, making it full screen (in a tab) Triggering the plugin
" again from the zoomed in tab brings it back to its original pane location
""
fun helpers#utils#zoom()
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
fun! helpers#utils#jumplast() abort
  if empty(&buftype) && index(['diff', 'gitcommit'], &filetype, 0, v:true) == -1
    if line("'\"") >= 1 && line("'\"") <= line('$')
      execute 'normal! g`"zz'
    endif
  endif
endfun

""
" Remove trailing whitespace
""
fun! helpers#utils#stripTrailingWhitespace() abort
  " Don't strip on these filetypes
  if &ft =~ 'ruby\|javascript\|perl\|gitsendemail\|markdown'
    return
  endif
  %s/\s\+$//e
endfun
