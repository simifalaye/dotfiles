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
nnoremap <C-q> :q<cr>

" Text manipulation
" -------------------

" @TextObj : ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<cr>
" @TextObj : iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<cr>
" Substitute motion1 with clipboard (ex: siw)
nmap s <plug>(SubversiveSubstitute)
" Substitute line with clipboard
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
" Substitute motion1 in motion2 with prompt (ex: siwip)
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Auto-bracket.
inoremap {<CR> {<CR>}<Esc>O
" +/- increment and decrement.
nnoremap + <C-a>| nnoremap - <C-x>

" Ease of use remaps
" ------------------

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk
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
" Y consistent with C and D
noremap Y y$
" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv
" reselect pasted text
nnoremap <leader>v V`]

" Files Buffers, Splits and Tabs
" ------------------------------

" Split window
noremap <leader>- :<C-u>split<CR>
noremap <leader>\ :<C-u>vsplit<CR>
" Tab navigation
nnoremap <leader><right> gT
nnoremap <leader><left> gt
" Move through buffers on tab line
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprev<CR>
" Toggle NERDTree
nmap <leader><leader> :NERDTreeToggle<CR>
nmap <leader>f :silent! NERDTreeFind<CR>
" Backspace toggles between buffers
nnoremap <BS> <C-^>

" Code completion and snippets
" ----------------------------

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Press enter key to trigger snippet expansion
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" FZF and Fugitive
" ----------------
nnoremap <silent><C-p> :Files<cr>
nnoremap <silent><C-e> :Snippets<cr>
nnoremap <silent><C-g> :Rg<CR>
nnoremap <silent>; :Buffers<CR>
