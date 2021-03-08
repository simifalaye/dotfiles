" LSP client for code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = [
        \ 'coc-clangd',
        \ 'coc-lua',
        \ 'coc-rls',
        \ 'coc-snippets',
        \]
  " Coc config. Execute ':h coc-configuration' to see all available settings
  let g:coc_user_config = {
    \ 'codeLens.enable': v:true,
    \ 'clangd.arguments': [
      \ '--background-index',
      \ '--suggest-missing-includes',
      \ '--header-insertion', 'iwyu',
      \ '--query-driver', '/home/**/*-vcm-linux-*',
    \ ],
    \ 'diagnostic.enable': v:true,
    \ 'diagnostic.enableSign': v:false,
    \ 'diagnostic.maxWindowHeight': 20,
    \ 'explorer.previewAction.onHover': v:false,
    \ 'suggest.enablePreview': v:true,
    \ 'suggest.detailField': "abbr",
    \ 'suggest.maxCompleteItemCount': 30,
    \ 'snippets.ultisnips.directories': [ 'UltiSnips', 'plugged/vim-snippets/UltiSnips' ],
  \ }

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

" Applying codeAction to the selected region.
" Example => `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>cf  <Plug>(coc-fix-current)
" CocList mappings
nnoremap <silent><leader>cd :<C-u>CocList diagnostics<CR>
nnoremap <silent><leader>co :<C-u>CocList outline<CR>
nnoremap <silent><leader>cr :<C-u>CocListResume<CR>

" Snippets: expand snippet
imap <C-l> <Plug>(coc-snippets-expand)
