" General Mappings
" ================

" reload .vimrc
nnoremap <leader>r :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>

" Quickly switch vim modes
imap jk <esc>
cmap jk <esc>

" Hide last search highlights
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Spell-check set to leader+o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Save and quit
" -------------

noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR><C-C>
inoremap <silent> <C-S> <C-O>:update<CR><C-C>
nmap <leader>q :NERDTreeClose<cr>:Sayonara<cr>
nnoremap <C-x> :q<cr>

" Text manipulation
" -------------------

" ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<cr>
" iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<cr>

" substitute motion1 with clipboard (ex: siw)
nmap s <plug>(SubversiveSubstitute)
" substitute line with clipboard
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
" substitute motion1 in motion2 with prompt (ex: siwip)
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
" substitue word in range with prompt
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Ease of use remaps
" ------------------

" Easy moves through lines (and wrapped ones)
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
xnoremap B ^
xnoremap E $
" Remap x to do cut actions
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D
" Don't copy when doing edit actions
nnoremap c "_c
xnoremap c "_c
nnoremap cc "_S
nnoremap C "_C
xnoremap C "_C
nnoremap d "_d
xnoremap d "_d
nnoremap dd "_dd
nnoremap D "_D
nnoremap D "_D
" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv
" reselect pasted text
nnoremap <leader>v V`]
" % matchit shortcut, but only in normal mode!
nmap <Tab> %

" Files Buffers, Splits and Tabs
" ------------------------------

" Split window
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>
" Tab navigation
nnoremap <leader><right> gT
nnoremap <leader><left> gt
" Move through buffers on tab line
nnoremap <S-l> :bnext<CR>
nnoremap <S-H> :bprev<CR>
" Toggle NERDTree
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>f :silent! NERDTreeFind<CR>

" Code completion and snippets
" ----------------------------
inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"
imap <C-j> <Plug>(neosnippet_expand_or_jump)
smap <C-j> <Plug>(neosnippet_expand_or_jump)
xmap <C-j> <Plug>(neosnippet_expand_target)

" FZF and Fugitive
" ----------------
nnoremap <silent><C-p> :GFiles<cr>
nnoremap <silent><C-e> :Snippets<cr>
nnoremap <silent><C-f> :Files<CR>
nnoremap <silent><C-g> :Rg<CR>
nnoremap <silent>; :Buffers<CR>
