" General Mappings
" ----------------
inoremap jk <Esc>
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<CR>:echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
nnoremap <localleader>u :so $MYVIMRC<bar>PlugUpdate<CR>
nnoremap <localleader>U :PlugUpgrade<CR>

" Save and quit
" -------------
command! Bclose call functions#bufcloseCloseIt()
cnoremap W!        w !sudo tee % >/dev/null
nnoremap <leader>c :cclose<CR>
noremap  <leader>w :update<CR>
nmap     <leader>q :Bclose<CR>
nmap     Q         :q<CR>
nmap     W         :wa<CR>
nmap     X         :qa!<CR>

" Remaps
" -------
nnoremap j     gj
nnoremap k     gk
nnoremap m     d
nnoremap mm    dd
nnoremap M     D
nnoremap Y     y$
nnoremap /     /\v
nnoremap n     nzz
nnoremap N     Nzz
nnoremap p     p`[v`]=
nnoremap <Tab> %
vnoremap /     /\v
vnoremap .     :normal .<CR>
vnoremap y     ygv<Esc>
vnoremap <     <gv
vnoremap >     >gv
xnoremap m     d
map      f     <Plug>Sneak_s
map      F     <Plug>Sneak_S

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
" Find the conflict line of git
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" Add closing brackets
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
" Highlight pasted text | remove highlight
nnoremap <leader>p V`]
nnoremap <leader>/ :nohl<CR>

" Files Buffers, Splits and Tabs
" ------------------------------
" Tab/buffer navigation, zoom
nnoremap <Right> gT | nnoremap <Left> gt
nnoremap H :bprevious<CR> | nnoremap L :bnext<CR>
nnoremap <BS> <C-^>
nnoremap <leader>z :call functions#zoom()<CR>
" NERDTree
nnoremap <silent><C-n> :call functions#nerdTreeToggleFind()<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent>,     :Buffers<CR>
nnoremap <silent>t     :BTags<CR>
" Split with startify
nnoremap <silent><Leader>v :vsplit \| :Startify<CR>
nnoremap <silent><Leader>h :split \| :Startify<CR>

" Git
" ----------------
nnoremap <silent> gib :Gblame<Enter>
nnoremap <silent> gid :Gdiff<Enter>
nnoremap <silent> gil :0Glog<Enter>
nnoremap <silent> gis :Gstatus<Enter>

" Completion
" ----------------
" Expand with tab, shift-tab and enter
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"
" Key bindings for vim-lsp.
nnoremap <silent> gd :LspDefinition<CR>
nnoremap <silent> gr :LspReferences<CR>
nnoremap <silent> gi :LspImplementation<CR>
nnoremap <silent> gh :LspHover<CR>
nnoremap <silent> ]d :LspNextDiagnostic<CR>
nnoremap <silent> [d :LspPreviousDiagnostic<CR>
nnoremap <silent> <A-d> :LspDocumentDiagnostics<CR>
nnoremap <silent> <A-r> :LspRename<CR>
