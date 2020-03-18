" ==============================================================
" Coc.nvim helpers
" ==============================================================

""
" Check if backspace is hit
""
fun! helpers#coc#checkBackspace()
  let l:column = col('.') - 1
  return !l:column || getline('.')[l:column - 1] =~ '\s'
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
  " Use tab for trigger completion with characters ahead and navigate.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ helpers#coc#checkBackspace() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " CocList mappings
  nnoremap <silent> <leader>d  :CocList diagnostics<cr>
  nnoremap <silent> <leader>o  :CocList outline<cr>
  nnoremap <silent> <leader>l  :<C-u>CocListResume<CR>
  " Use K to show documentation in preview window
  nnoremap <silent> K :call helpers#coc#showDocumentation()<CR>
  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)
endfun
