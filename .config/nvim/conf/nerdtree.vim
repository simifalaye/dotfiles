" File explorer
Plug 'preservim/nerdtree'
  let NERDTreeShowHidden          = v:true
  let NERDTreeMinimalUI           = v:true
  let NERDTreeWinPos              = "right"
  let NERDTreeMinimalMenu         = v:true
  let NERDTreeAutoDeleteBuffer    = v:true
  let NERDTreeDirArrowExpandable  = " "
  let NERDTreeDirArrowCollapsible = " "

nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

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
