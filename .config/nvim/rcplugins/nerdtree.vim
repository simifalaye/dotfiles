" File explorer
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
  let NERDTreeShowHidden          = v:true
  let NERDTreeDirArrowExpandable  = "\u00a0" " make arrows invisible
  let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible

nnoremap <leader>f :NERDTreeToggle<CR>
nnoremap <leader>y :NERDTreeFind<CR>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 &&
      \ winnr('$') == 1 &&
      \ exists('b:NERDTree') &&
      \ b:NERDTree.isTabTree() | quit | endif
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 &&
      \ isdirectory(argv()[0]) &&
      \ !exists('s:std_in') |
      \ execute 'NERDTree' argv()[0] | wincmd p | enew |
      \ execute 'cd '.argv()[0] | endif
