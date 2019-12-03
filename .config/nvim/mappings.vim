" General Mappings
" ----------------

" reload .vimrc
nnoremap <localleader>r :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>
" vim-plug
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<cr>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<cr>
nnoremap <localleader>u :so $MYVIMRC<bar>PlugUpdate<cr>
nnoremap <localleader>U :PlugUpgrade<cr>

" Quickly switch back to normal mode
inoremap jk <Esc>
cmap jk <esc>

" Save and quit
" -------------

noremap <silent> <leader>w :update<CR>
nmap <leader>q :Bdelete<cr>
nmap <leader>Q :Bwipeout<cr>
nmap <leader>x :q<cr>
nmap <leader>X :q!<cr>
cnoremap w!! w !sudo tee % >/dev/null

" Text manipulation
" -------------------

" @TextObj : ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<cr>
" @TextObj : iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<cr>
" Copy and paste
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
" Substitute motion1 with clipboard (ex: siw, ss, S)
nmap s <plug>(SubversiveSubstitute)
xmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
" Substitute motion1 in motion2 with prompt or with vim-abolish (ex: <leader>siwip)
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader><leader>s <plug>(SubversiveSubvertRange)
xmap <leader><leader>s <plug>(SubversiveSubvertRange)
" Start interactive EasyAlign in visual/normal mode (e.g. vipga, gaip)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Remaps
" -------

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk
" Remap m (move) to do cut actions
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D
" Don't copy when doing edit actions
nnoremap c "_c
xnoremap c "_c
nnoremap cc "_S
nnoremap C "_C
xnoremap C "_C
nnoremap d "_d
xnoremap d "_d
nnoremap dd "_dd
nnoremap D "_D
nnoremap D "_D
" Y consistent with C and D
noremap Y y$
" Vmap for maintain Visual Mode after shifting
vmap < <gv
vmap > >gv
" reselect pasted text
nnoremap <leader>v V`]
" Always search using regex
nnoremap / /\v
vnoremap / /\v
" Hide last search highlights
nnoremap <silent> <leader>/ :nohlsearch<CR>
" Spell-check set to leader+o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Files Buffers, Splits and Tabs
" ------------------------------

" Split window
noremap <leader>- :<C-u>split<CR>
noremap <leader>\ :<C-u>vsplit<CR>
" Tab navigation
nnoremap <Tab> gT
nnoremap <S-Tab> gt
" Move through buffers on tab line
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprev<CR>
" NERDTree
noremap <silent> <Leader>n :NERDTreeToggle<CR>
noremap <silent> <Leader>f :NERDTreeFind<CR>
" Backspace toggles between buffers
nnoremap <BS> <C-^>
" Fzf
nnoremap <silent><C-s> :Snippets<CR>
nnoremap <silent><C-g> :Rg<CR>
nnoremap <silent>; :Buffers<CR>
nnoremap <silent>, :SmartFiles<CR>

" Code completion and snippets
" ----------------------------

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Git
" ----------------
nnoremap <localleader>gt :SignifyToggle<CR>
nnoremap <localleader>gd :SignifyHunkDiff<CR>
nnoremap <localleader>gu :SignifyHunkUndo<CR>
