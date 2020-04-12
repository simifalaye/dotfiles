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
" Don't close window, when deleting a buffer
""
fun! helpers#utils#bufcloseCloseIt()
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

""
" Make custom text objects
"
" @param {dict} to: dictionary of mappings and their functions
"   key{string}: file types, comma separated ex. 'cpp,c' (_ is all files)
"   value{dict[list]}:
"     key{string}: mapping
"     value{string}: text object function (ex: 'ggVG')
""
fun! helpers#utils#makeTextObjs(to) abort
  let to = a:to

  " For all filetypes
  for [k, m] in to._
    execute 'onoremap <silent> ' . k . ' :normal! ' . m . '<CR>'
    execute 'xnoremap <silent> ' . k . ' :<C-u>normal! ' . m . '<CR>'
  endfor
  call remove(to, '_')

  " For specific types
  augroup MyTextObjects
    autocmd!
    for ft in keys(to)
      for [k, m] in to[ft]
        execute 'autocmd FileType ' . ft .
              \ ' onoremap <buffer> <silent> ' . k .
              \ ' :normal! ' . m . '<CR>'
        execute 'autocmd FileType ' . ft .
              \ ' xnoremap <buffer> <silent> ' . k .
              \ ' :<C-u>normal! ' . m . '<CR>'
      endfor
    endfor
  augroup END
endfun

""
" Open the current URL
" - If line begins with "Plug" open the github page
" of the plugin.
""
fun! helpers#utils#open_url() abort " {{{1
  let cl = getline('.')
  let url = escape(matchstr(cl, '[a-z]*:\/\/\/\?[^ >,;()]*'), '#%')
  if cl =~# 'Plug'
    let pn = cl[match(cl, "'", 0, 1) + 1 :
          \ match(cl, "'", 0, 2) - 1]
    let url = printf('https://github.com/%s', pn)
  endif
  if !empty(url)
    let url = substitute(url, "'", '', 'g')
    let wmctrl = executable('wmctrl') && v:windowid isnot# 0 ?
          \ ' && wmctrl -ia ' . v:windowid : ''
    exe 'silent :!' . (g:is_unix ?
          \   'x-www-browser ' . shellescape(url) :
          \   ' start "' . shellescape(url)) .
          \ wmctrl .
          \ (g:is_unix ? ' 2> /dev/null &' : '')
    if !g:is_gui | redraw! | endif
  endif
endfun

" List and select marks
function! Marks()
  marks abcdefghijklmnopqrstuvwxyz.
  echo 'Jump to mark: '
  let mark=nr2char(getchar())
  redraw
  execute 'normal! `'.mark
endfunction

