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
" Specify the coc plugins to install
""
fun! helpers#coc#plugins()
  let l:global_exts = [
        \ 'coc-json',
        \ 'coc-lua',
        \ 'coc-snippets',
        \ 'coc-sh',
        \ 'coc-word',
        \]
  let l:home_pc_exts = [
        \ 'coc-css',
        \ 'coc-elixir',
        \ 'coc-emmet',
        \ 'coc-html',
        \ 'coc-rls',
        \]

  if g:is_wsl
    let g:coc_global_extensions = l:global_exts + l:home_pc_exts
  else
    let g:coc_global_extensions = l:global_exts
  endif
endfun

""
" Coc mappings
""
fun! helpers#coc#mappings()
  " Use tab to cycle through completion items and <CR> to accept
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ helpers#coc#checkBackspace() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif
  " Use `[d` and `]d` to navigate diagnostics
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gf <Plug>(coc-references)
  " CocList mappings
  nnoremap <silent> go :<C-u>CocList outline<CR>
  nnoremap <silent> gl :<C-u>CocListResume<CR>
  " Use K to show documentation in preview window
  nnoremap <silent> K :call helpers#coc#showDocumentation()<CR>
  " Remap for rename current word
  nmap <leader>cr <Plug>(coc-rename)
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
endfun
