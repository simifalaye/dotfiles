" General Mappings
" ----------------
inoremap jk <Esc>
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
" Save and quit
command! Bclose call helpers#utils#bufcloseCloseIt()
command! BufOnly silent! execute "%bd|e#|bd#"
command! SudoWrite w !sudo tee > /dev/null %
noremap <leader>w :update<CR>
noremap <leader>q :q<CR>
noremap <leader>Q :qa<CR>
noremap <leader>c :Bclose<CR>
noremap <leader>C :BufOnly<CR>

" Remaps
" -------
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
inoremap {<CR> {<CR>}<Esc>O
inoremap {;    {<CR>};<Esc>O
nnoremap p     p`[v`]=
nnoremap //    :nohl<CR>

" Editing
" ---------
" Replace word forward and backward (dot repeatable)
nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
" Add (count) line above and below
nnoremap <leader>j o<ESC>'[k | nnoremap <leader>k O<ESC>j
" Find the conflict line of git
nnoremap <leader>gc /\v^[<\|=>]{7}( .*\|$)<CR>
" Align text and underline titles
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap gu yyp0v$r-
nmap gU yyp0v$r=
" Text Object (inner-{line,entire,viewable})
call helpers#utils#makeTextObjs({
      \   '_' : [
      \       ['il', '^vg_'],
      \       ['ie', 'ggVG'],
      \       ['iv', 'HVL'],
      \   ]
      \ })

" Files, Buffers, Splits and Tabs
" --------------------------------
" Zoom
nnoremap <leader>z :call helpers#utils#zoom()<CR>
" Navigation
nnoremap <C-h> <C-w>h | nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k | nnoremap <C-j> <C-w>j
nnoremap <C-p> :bp<CR> | nnoremap <C-n> :bn<CR>
" Explorer
nnoremap <silent><leader>n :Fern . -reveal=% -drawer -width=40 -toggle<CR>
" Fzf
nnoremap <silent><leader>p :SmartFiles<CR>
nnoremap <silent><leader>f :Find<CR>
nnoremap <silent><CR>  :Buffers<CR>
" Git
nnoremap <silent> gib :Gblame<CR>
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gil :Glog<CR>
nnoremap <silent> gis :Gstatus<CR>
" Open URL
nnoremap <silent> gx :call helpers#utils#open_url()<CR>

" Completion
" ----------
call helpers#coc#mappings()
