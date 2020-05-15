" General Mappings & Commands
" -----------------------------
command! Bclose silent! call helpers#utils#bufcloseCloseIt()
command! BufOnly silent! execute "%bd|e#|bd#"
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
" Save and quit
nnoremap <leader>w  :update<CR>
nnoremap <leader>bo :BufOnly<CR>
nnoremap <leader>q  :Bclose<CR>

" Remaps
" -------
inoremap jk               <Esc>
nnoremap ;                :
nnoremap Q                @q
nnoremap j                gj
nnoremap k                gk
vnoremap y                ygv<Esc>
nnoremap Y                y$
nnoremap n                nzz
nnoremap N                Nzz
nnoremap /                ms/\v
nnoremap ?                ms?\v
vnoremap <                <gv
vnoremap >                >gv
nnoremap p                p`[v`]=
nnoremap g/               :nohl<CR>
nnoremap gv               `[v`]
inoremap {<CR>            {<CR>}<Esc>O
inoremap {;               {<CR>};<Esc>O
nnoremap <leader><leader> <c-^>

" Editing
" ---------
call helpers#coc#mappings()
" Align text and underline titles
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap gu yyp0v$r- | nmap gU yyp0v$r=
" Text Objects (inner-{line,entire,viewable})
call helpers#utils#makeTextObjs({
      \   '_' : [
      \       ['il', '^vg_'],
      \       ['ie', 'ggVG'],
      \       ['iv', 'HVL'],
      \   ]
      \ })

" Files, Buffers, Splits and Tabs
" --------------------------------
" Explorer
nnoremap <leader>; :Fern . -stay<CR>
" Fzf
nnoremap <silent><C-p> :Files<CR>
nnoremap <silent><C-g> :GitFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent>,     :Buffers<CR>
nnoremap <silent>_     :Marks<cr>
" Git
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gis :Gstatus<CR>
" Make executable
nnoremap <leader>x :! chmod +x %<CR>
" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
