" General Mappings & Commands
" -----------------------------
command! Bclose call helpers#utils#bufcloseCloseIt()
command! BufOnly silent! execute "%bd|e#|bd#"
command! SudoWrite w !sudo tee > /dev/null %

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
inoremap jk    <Esc>
nnoremap j     gj
nnoremap k     gk
nnoremap x     d
xnoremap x     d
nnoremap xx    dd
nnoremap X     D
vnoremap y     ygv<Esc>
nnoremap Y     y$
nnoremap n     nzz
nnoremap N     Nzz
nnoremap /     /\v
vnoremap <     <gv
vnoremap >     >gv
nnoremap p     p`[v`]=
nnoremap g/    :nohl<CR>

" Editing
" ---------
" Replace word forward and backward (dot repeatable)
nnoremap cn /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap cN ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
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
" List marks
command! Marks call Marks()
nnoremap <silent>_ :call Marks()<cr>
" Improve scroll
nnoremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
nnoremap <expr> <C-y> (line("w0") <= 1 ? "k" : "3\<C-y>")


" Files, Buffers, Splits and Tabs
" --------------------------------
" Explorer
nnoremap <silent><leader>e :Fern . -reveal=% -stay<CR>
" Splits
nnoremap <leader>z :call helpers#utils#zoom()<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent><CR>  :Buffers<CR>
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
