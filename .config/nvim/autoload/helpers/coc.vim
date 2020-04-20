" ==================
" Coc.nvim helpers
" ==================

""
" Check if backspace is hit
""
fun! helpers#coc#checkBackspace()
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun

""
" Show documentation for coc if not in a vim buffer
""
fun! helpers#coc#showDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

""
" Coc mappings
""
fun! helpers#coc#mappings()
  " Use tab to confirm completion of anything and for snippet jumping
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ helpers#coc#checkBackspace() ? "\<TAB>" :
        \ coc#refresh()
  let g:coc_snippet_next = '<tab>'
  let g:coc_snippet_prev = '<s-tab>'
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " CocList mappings
  nnoremap <silent> <leader>cd  :CocList diagnostics<cr>
  nnoremap <silent> <leader>co  :CocList outline<cr>
  nnoremap <silent> <leader>cl  :<C-u>CocListResume<CR>
  " Use K to show documentation in preview window
  nnoremap <silent> K :call helpers#coc#showDocumentation()<CR>
  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)
endfun
