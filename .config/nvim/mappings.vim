" General Mappings
" ----------------
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<cr>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<cr>
nnoremap <localleader>u :so $MYVIMRC<bar>PlugUpdate<cr>
nnoremap <localleader>U :PlugUpgrade<cr>
" Quickly switch back to normal mode
inoremap jk <Esc>l

" Save and quit
" -------------
nnoremap <leader>a :cclose<CR>
noremap  <leader>w :update<CR>
nmap     <leader>q :Bdelete<CR>
nmap     <leader>Q :Bwipeout<CR>
nmap     <leader>x :q<CR>
nmap     <leader>X :q!<CR>
cnoremap w!!       w !sudo tee % >/dev/null

" Remaps
" -------
nnoremap j     gj
nnoremap k     gk
nnoremap m     d
xnoremap m     d
nnoremap mm    dd
nnoremap M     D
noremap  Y     y$
vnoremap <     <gv
vnoremap >     >gv
nnoremap /     /\v
vnoremap /     /\v
vnoremap .     :normal .<cr>
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap //    :nohl<CR>

" Text manipulation
" -------------------
" @TextObjects: ie = inner entire buffer, iv = current viewable text
onoremap ie :exec "normal! ggVG"<CR>
onoremap iv :exec "normal! HVL"<CR>
" Start interactive EasyAlign in visual/normal mode (e.g. vipga, gaip)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" Toggle common options
nnoremap cos :set spell!<Enter>
nnoremap coh :set hlsearch!<Enter>
" Reselect pasted text
nnoremap <leader>v V`]

" Files Buffers, Splits and Tabs
" ------------------------------
" Tab navigation
nnoremap <Tab> gT
nnoremap <S-Tab> gt
" Toggles between buffers
nnoremap <BS> <C-^>
" Zoom
nnoremap <leader>z :call functions#zoom()<CR>
" Fzf
nnoremap <silent><C-s> :Snippets<CR>
nnoremap <silent><C-g> :Rg<CR>
nnoremap <silent>;     :Buffers<CR>
nnoremap <silent>,     :SmartFiles<CR>
" NERDTree
noremap <silent> <C-n> :NERDTreeToggle<CR>
noremap <silent> <C-f> :NERDTreeFind<CR>

" Code completion and snippets
" ----------------------------
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ functions#checkBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Git
" ----------------
nnoremap <silent> gib :Gblame<Enter>
nnoremap <silent> gid :Gdiff<Enter>
nnoremap <silent> gil :0Glog<Enter>
nnoremap <silent> gis :Gstatus<Enter>
