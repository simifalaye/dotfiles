" General Mappings & Commands
" -----------------------------
command! Bclose call helpers#utils#bufcloseCloseIt()
command! BufOnly silent! execute "%bd|e#|bd#"
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
" Save and quit
noremap <leader>w :update<CR>
noremap <leader>q :Bclose<CR>
noremap <leader>Q :BufOnly<CR>

" Remaps
" -------
inoremap jk        <Esc>
nnoremap x         "_x
nnoremap X         "_x
nnoremap j         gj
nnoremap k         gk
vnoremap y         ygv<Esc>
nnoremap Y         y$
nnoremap Q         @q
nnoremap n         nzz
nnoremap N         Nzz
nnoremap /         ms/\v
nnoremap ?         ms?\v
vnoremap <         <gv
vnoremap >         >gv
nnoremap p         p`[v`]=
nnoremap g/        :nohl<CR>
nnoremap gv        `[v`]
nnoremap <leader>l <C-^>

" Editing
" ---------
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
nnoremap <silent><leader>n :Dirvish<CR>
nnoremap <silent><leader>f :Dirvish %:h<CR>
" Splits & Tabs
nnoremap <leader>z :call helpers#utils#zoom()<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent><CR>  :Buffers<CR>
nnoremap <silent>_     :Marks<cr>
" Git
nnoremap <silent> gib :Gblame<CR>
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gil :Glog<CR>
nnoremap <silent> gis :Gstatus<CR>
" Open URL
nnoremap <silent> gx :call helpers#utils#open_url()<CR>

" Completion
" ------------
call helpers#coc#mappings()
