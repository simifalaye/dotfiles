" General Mappings & Commands
" -----------------------------
command! BufOnly silent! execute "%bd|e#|bd#"
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
" Save and quit
nnoremap <leader>w  :update<CR>
nnoremap <leader>bo :BufOnly<CR>
nnoremap <leader>q  :Sayonara<CR>
nnoremap Q          :Sayonara!<CR>

" Remaps
" -------
inoremap jk        <Esc>
nnoremap x         "_x
nnoremap X         "_x
nnoremap j         gj
nnoremap k         gk
vnoremap y         ygv<Esc>
nnoremap Y         y$
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
nnoremap <C-e>     3<C-e>
nnoremap <C-y>     3<C-y>
inoremap {<CR>     {<CR>}<Esc>O
inoremap {;        {<CR>};<Esc>O

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
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>f :NERDTreeFind<CR>
" Splits & Tabs
nnoremap <leader>z :call helpers#utils#zoom()<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent>,     :Buffers<CR>
nnoremap <silent>_     :Marks<cr>
" Git
nnoremap <silent> gib :Gblame<CR>
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gil :Glog<CR>
nnoremap <silent> gis :Gstatus<CR>
" Open URL
nnoremap <silent>gx :call helpers#utils#open_url()<CR>
" Doxygen toolkit
nnoremap <silent><leader>dx :Dox<CR>

" Completion
" ------------
call helpers#coc#mappings()
