" LSP client for code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = [
        \ 'coc-clangd',
        \ 'coc-json',
        \ 'coc-lua',
        \ 'coc-rls',
        \ 'coc-snippets',
        \ 'coc-word',
        \]

" Use tab to cycle through completion items and <CR> to accept
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>checkBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
fun! s:checkBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfun

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show documentation in preview window
nnoremap <silent> K :call <SID>cocShowDocumentation()<CR>
fun! s:cocShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfun

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" CocList mappings
nnoremap <silent><leader>cd :<C-u>CocList diagnostics<CR>
nnoremap <silent><leader>co :<C-u>CocList outline<CR>
nnoremap <silent><leader>cr :<C-u>CocListResume<CR>

" coc-snippets => expand snippet
imap <C-l> <Plug>(coc-snippets-expand)
