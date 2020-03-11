" General Mappings
" ----------------
inoremap jk <Esc>
" Config mappings
nnoremap <localleader>r :so $MYVIMRC<bar>echo ".vimrc reloaded"<CR>
nnoremap <localleader>i :so $MYVIMRC<bar>PlugInstall<CR>
nnoremap <localleader>c :so $MYVIMRC<bar>PlugClean<CR>
" Save and quit
command! Bclose call functions#bufcloseCloseIt()
command! BufOnly silent! execute "%bd|e#|bd#"
command! SudoWrite w !sudo tee > /dev/null %
noremap <leader>w :update<CR>
noremap <leader>q :q<CR>
noremap <leader>Q :qa<CR>
noremap <leader>c :Bclose<CR>
noremap <leader>C :BufOnly<CR>

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
nnoremap n         nzz
nnoremap N         Nzz
nnoremap /         /\v
vnoremap <         <gv
vnoremap >         >gv
inoremap {<CR>     {<CR>}<Esc>O
inoremap {;        {<CR>};<Esc>O
nnoremap p         p`[v`]=
nnoremap <leader>j o<ESC>'[k
nnoremap <leader>k O<ESC>j

" Editing
" ---------
" Find the conflict line of git
map <leader>gc /\v^[<\|=>]{7}( .*\|$)<CR>
" Highlight pasted text and remove highlight
nnoremap <leader>p V`] | nnoremap <leader>/ :nohl<CR>
" 'multiple-cursor' replacement
nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn
nnoremap c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN
" Align text
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" Text Object (inner-{line,entire,viewable})
xnoremap <silent>il :<c-u>normal! g_v^<cr>
onoremap <silent>il :<c-u>normal! g_v^<cr>
onoremap <silent>ie :<c-u>normal! ggVG<cr>
xnoremap <silent>ie :<c-u>normal! ggVG<cr>
onoremap <silent>iv :<c-u>normal! HVL<cr>
xnoremap <silent>iv :<c-u>normal! HVL<cr>

" Files, Buffers, Splits and Tabs
" --------------------------------
" Zoom
nnoremap <leader>z :call functions#zoom()<CR>
" Navigation
nnoremap <C-h> <C-w>h | nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k | nnoremap <C-j> <C-w>j
nnoremap <Left> :bp<CR> | nnoremap <Right> :bn<CR>
" Explorer
nnoremap <silent><C-n> :Fern . -reveal=%<CR>
" Fzf
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent><C-g> :SwitchSess<CR>
nnoremap <silent><CR>  :Buffers<CR>
" Git
nnoremap <silent> gib :Gblame<CR>
nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gil :Glog<CR>
nnoremap <silent> gis :Gstatus<CR>

" Completion
" ----------
call helpers#coc#mappings()
