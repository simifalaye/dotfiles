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
nnoremap n         nzz
nnoremap N         Nzz
vnoremap .         :normal .<cr>
nnoremap siw       "_diwP
nnoremap ss        "_ddP
nnoremap S         "_Dp
vnoremap y         ygv<Esc>
nnoremap <Tab>     %
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
" move selected lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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
nnoremap <silent>,     :Buffers<CR>
command! -bang -nargs=* -complete=dir SmartFiles call functions#smartFiles(<q-args>)
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
  nnoremap <silent> <C-f> :Find<CR>
endif
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
" Expand with tab and shift-tab
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ functions#checkBackspace() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Key bindings for vim-lsp.
nnoremap <silent> <C-]> :LspDefinition<cr>
nnoremap <silent> gr :LspReferences<cr>
nnoremap <silent> gd :LspDocumentSymbol<cr>
nnoremap <silent> gh :LspHover<cr>
nnoremap <f2> :LspRename<cr>
