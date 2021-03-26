" Run sync/asyc tasks
Plug 'tpope/vim-dispatch', {'on': [ 'Copen', 'Make', 'Dispatch', 'Start' ]}
  let g:dispatch_no_maps = 1

""
" Run the yocto compile and test binaries for quickly verifying code
"
" @param {bool} fg: Dispatch in the foreground instead of background
" @param {bool:def = false} dotest: Dispatch the test suite
""
fun! YoctoDispatch(fg, ...)
  let l:build = finddir('oe-workdir', expand('%:p:h').';')
  if (l:build == "")
    echo "Can't find local build directory oe-workdir"
    return
  endif

  let l:dotest = get(a:, 1, v:false)
  let l:bin = l:dotest == v:true ? "run.do_test" : "run.do_compile"
  let l:bang = a:fg == v:true ? "" : "!"

  " Run dispatch
  execute 'Dispatch' . l:bang . ' ' . l:build . '/**temp/' . l:bin
endfun

" leader + d (dispatch)
nnoremap <leader>dc :call YoctoDispatch(v:false)<CR>
nnoremap <leader>dC :call YoctoDispatch(v:true)<CR>
nnoremap <leader>dt :call YoctoDispatch(v:false, v:true)<CR>
nnoremap <leader>dT :call YoctoDispatch(v:true, v:true)<CR>
nnoremap <leader>do :execute "Copen \| resize 40"<CR>
