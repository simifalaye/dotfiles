" General Mappings
" ----------------
inoremap jk <Esc>
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>

" Save and quit
" -------------
command! Bclose call functions#bufcloseCloseIt()
cnoremap W!!       w !sudo tee % >/dev/null
noremap  <leader>w :update<CR>
nmap     <leader>q :Bclose<CR>
nmap     q         :q<CR>

" Remaps
" -------
nnoremap j         gj
nnoremap k         gk
nnoremap x         d
xnoremap x         d
nnoremap xx        dd
nnoremap X         D
vnoremap y         ygv<Esc>
nnoremap Y         y$
nnoremap /         /\v
nnoremap n         nzz
nnoremap N         Nzz
nnoremap p         p`[v`]=
vnoremap <         <gv
vnoremap >         >gv
nmap     s         <plug>(SubversiveSubstitute)
nmap     ss        <plug>(SubversiveSubstituteLine)
nmap     S         <plug>(SubversiveSubstituteToEndOfLine)
nmap     <leader>s <plug>(SubversiveSubstituteRange)
xmap     <leader>s <plug>(SubversiveSubstituteRange)
xmap     ga        <Plug>(EasyAlign)
nmap     ga        <Plug>(EasyAlign)

" Editing
" -------------------
" @TextObjects: ie = inner entire buffer, iv = current viewable text
onoremap ie :exec "normal! ggVG"<CR>
onoremap iv :exec "normal! HVL"<CR>
" Toggle common options
nnoremap cos :set spell!<Enter>
" Find the conflict line of git
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" Add closing brackets
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O
" Highlight pasted text | remove highlight
nnoremap <leader>p V`]
nnoremap <leader>/ :nohl<CR>

" Files Buffers, Splits and Tabs
" ------------------------------
" Tab/buffer navigation, zoom
nnoremap <S-h> :bp<CR> | nnoremap <S-l> :bn<CR>
nnoremap <leader>l <C-^>
nnoremap <leader>z :call functions#zoom()<CR>
" NERDTree
nnoremap <silent><C-n> :NERDTreeToggle<CR>
nnoremap <silent><leader>n :NERDTreeFind<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent><C-g> :SwitchSess<CR>
nnoremap <silent>,     :Buffers<CR>
nnoremap <silent>t     :BTags<CR>
" Split with startify
nnoremap <silent><Leader>v :vsplit<bar>Startify<CR>
nnoremap <silent><Leader>h :split<bar>Startify<CR>
" Delete all buffers except this
command! BufOnly silent! execute "%bd|e#|bd#"
nnoremap <Leader>bd :BufOnly<CR>

" Git
" ----------------
nnoremap <silent> gib :Gblame<CR>
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gil :Glog<CR>
nnoremap <silent> gis :Gstatus<CR>

" Coc
" ----
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
" Yank list
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
