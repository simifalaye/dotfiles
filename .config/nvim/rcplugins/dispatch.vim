" Run sync/asyc tasks
Plug 'tpope/vim-dispatch', {'on': [ 'Copen', 'Make', 'Dispatch', 'Start' ]}
  let g:dispatch_no_maps = 1

""
" Run the yocto compile and test binaries for quickly verifying code
"
" @param {bool} silent: Dispatch in the background instead of foreground
" @param {bool:def = false} dotest: Dispatch the test suite
""
fun! YoctoDispatch(silent, ...)
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

" leader + r (run)
nnoremap <leader>rc :call YoctoDispatch(v:false)<CR>
nnoremap <leader>rC :call YoctoDispatch(v:true)<CR>
nnoremap <leader>rt :call YoctoDispatch(v:false, v:true)<CR>
nnoremap <leader>rT :call YoctoDispatch(v:true, v:true)<CR>
nnoremap <leader>ro :Copen<CR>
