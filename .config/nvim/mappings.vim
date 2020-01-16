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
cnoremap W!        w !sudo tee % >/dev/null
nnoremap <leader>a :cclose<CR>
noremap  <leader>w :update<CR>
nmap     <leader>q :Bdelete<CR>
nmap     <leader>Q :Bwipeout<CR>
nmap     <leader>x :q<CR>
nmap     <leader>X :q!<CR>

" Remaps
" -------
nnoremap ;         :
nnoremap j         gj
nnoremap k         gk
nnoremap m         d
xnoremap m         d
nnoremap mm        dd
nnoremap M         D
nnoremap Y         y$
vnoremap <         <gv
vnoremap >         >gv
nnoremap /         /\v
vnoremap /         /\v
vnoremap .         :normal .<cr>
nnoremap siw       "_diwP
nnoremap ss        "_ddP
nnoremap S         "_Dp
vnoremap y         ygv<Esc>
nnoremap <C-e>     5<C-e>
nnoremap <C-y>     5<C-y>
nnoremap <leader>/ :nohl<CR>

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
" Reselect pasted text
nnoremap <leader>p V`]
" find the conflict line of git
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Files Buffers, Splits and Tabs
" ------------------------------
" Tab/buffer navigation, zoom
nnoremap <C-Right> gT | nnoremap <C-Left> gt
nnoremap H :bprevious<CR> | nnoremap L :bnext<CR>
nnoremap <BS> <C-^>
nnoremap <leader>z :call functions#zoom()<CR>
" Fzf and NERDTree
nnoremap <silent><C-s> :Snippets<CR>
nnoremap <silent><C-g> :Rg<CR>
nnoremap <silent><C-p> :SmartFiles<CR>
nnoremap <silent><CR>  :Buffers<CR>
nnoremap <silent><C-n> :call functions#nerdTreeToggleFind()<CR>
" Split with startify
nnoremap <silent><Leader>v :vsplit \| :Startify<CR>
nnoremap <silent><Leader>h :split \| :Startify<CR>

" Git
" ----------------
nnoremap <silent> gib :Gblame<Enter>
nnoremap <silent> gid :Gdiff<Enter>
nnoremap <silent> gil :0Glog<Enter>
nnoremap <silent> gis :Gstatus<Enter>
