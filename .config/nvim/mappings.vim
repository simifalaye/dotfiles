" General Mappings
" ----------------
inoremap jk <Esc>
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
" Save and quit
command! Bclose call functions#bufcloseCloseIt()
cnoremap W!!       w !sudo tee % >/dev/null
noremap  <leader>w :update<CR>
nmap     <leader>q :q<CR>
nmap     q         :Bclose<CR>
nmap     Q         :qa<CR>

" Remaps
" -------
nnoremap 0     ^
vnoremap 0     ^
nnoremap j     gj
nnoremap k     gk
nnoremap x     d
xnoremap x     d
nnoremap xx    dd
nnoremap X     D
vnoremap y     ygv<Esc>
nnoremap Y     y$
nnoremap /     /\v
nnoremap n     nzz
nnoremap N     Nzz
nnoremap p     p`[v`]=
vnoremap <     <gv
vnoremap >     >gv
inoremap {<CR> {<CR>}<Esc>O
inoremap {;    {<CR>};<Esc>O

" Editing
" ---------
" Find the conflict line of git
map <leader>gc /\v^[<\|=>]{7}( .*\|$)<CR>
" Highlight pasted text and remove highlight
nnoremap <leader>p V`] | nnoremap <leader>/ :nohl<CR>
" Subversive
nmap     s         <plug>(SubversiveSubstitute)
nmap     ss        <plug>(SubversiveSubstituteLine)
nmap     S         <plug>(SubversiveSubstituteToEndOfLine)
nmap     <leader>s <plug>(SubversiveSubstituteRange)
xmap     <leader>s <plug>(SubversiveSubstituteRange)
" Align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" Text Object (inner-{line,entire,viewable}
xnoremap <silent>il :<c-u>normal! g_v^<cr>
onoremap <silent>il :<c-u>normal! g_v^<cr>
onoremap <silent>ie :<c-u>normal! ggVG<cr>
xnoremap <silent>ie :<c-u>normal! ggVG<cr>
onoremap <silent>iv :<c-u>normal! HVL<cr>
xnoremap <silent>iv :<c-u>normal! HVL<cr>

" Files, Buffers, Splits and Tabs
" --------------------------------
" Navigation
nnoremap <leader><Tab> <C-^>
nnoremap <leader>z :call functions#zoom()<CR>
nnoremap H :bp<CR> | nnoremap L :bn<CR>
" Explorer
nnoremap <silent><C-n> :Fern . -reveal=%<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent><C-g> :SwitchSess<CR>
nnoremap <silent>,     :Buffers<CR>
" Delete all buffers except this
command! BufOnly silent! execute "%bd|e#|bd#"
nnoremap <leader>bo :BufOnly<CR>
" Git
nnoremap <silent> gib :Gblame<CR>
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gil :Glog<CR>
nnoremap <silent> gis :Gstatus<CR>

" Completion
" ----------
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ helpers#coc#checkBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" CocList mappings
nnoremap <silent> <leader>d  :CocList diagnostics<cr>
nnoremap <silent> <leader>o  :CocList outline<cr>
" Use K to show documentation in preview window
nnoremap <silent> K :call helpers#coc#showDocumentation()<CR>
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
