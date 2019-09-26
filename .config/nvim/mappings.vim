"---------- General Mappings ----------"
" Exit insert and command mode with jk
imap jk <esc>
cmap jk <esc>

" reload .vimrc
nnoremap <leader>r :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>

" Hide last search highlights
nnoremap <silent> <leader><space> :nohlsearch<CR>

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

" Blackhole register
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

" Terminal bindings
nnoremap <Leader>ts <C-W>s:te<CR>
nnoremap <Leader>tv <C-W>v:te<CR>
tnoremap jk <C-\><C-n>

" Save file with ctrl + s, save
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR><C-C>
inoremap <silent> <C-S> <C-O>:update<CR><C-C>
nnoremap <C-x> :q<cr>

" Tab navigation
nnoremap <leader>l gT
nnoremap <leader>h gt

" Spell-check set to leader+o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>

" Quickly open a file in the same working dir
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" reselect pasted text
nnoremap <leader>v V`]

"---------- Plugin Mappings ----------"

"-- Sayonara --"
nmap <leader>q :NERDTreeClose<cr>:Sayonara<cr>

"-- Nerdtree --"
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>f :silent! NERDTreeFind<CR>

""-- EasyAlign --"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"-- Subversive --"
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

"-- FZF and Fugitive --"
nnoremap <silent><C-p> :GFiles<cr>
nnoremap <silent><C-e> :Snippets<cr>
nnoremap <silent><C-f> :Files<CR>
nnoremap <silent><C-g> :Rg<CR>
nnoremap <silent>; :Buffers<CR>

"-- Buftabline --"
nnoremap <S-l> :bnext<CR>
nnoremap <S-H> :bprev<CR>

"-- Deoplete and Neosnippets --"
inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"
imap <C-j> <Plug>(neosnippet_expand_or_jump)
smap <C-j> <Plug>(neosnippet_expand_or_jump)
xmap <C-j> <Plug>(neosnippet_expand_target)

"-- Clang Formatter --"
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
