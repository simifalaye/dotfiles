" reload .vimrc
nnoremap <leader>v :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>

" Exit insert and command mode with jk
imap jk <C-c>
imap kj <C-c>

" Hide last search highlights
nnoremap <silent> <leader><space> :nohlsearch<CR>

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Terminal bindings
nnoremap <Leader>ts <C-W>s:te<CR>
nnoremap <Leader>tv <C-W>v:te<CR>
tnoremap jk <C-\><C-n>

" Save file with ctrl + s, save
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR><C-C>
inoremap <silent> <C-S> <C-O>:update<CR><C-C>
nnoremap <C-x> :q<cr>

" Buffer Management
nnoremap L :bnext<CR>
nnoremap H :bprevious<CR>

" Tab navigation
nnoremap <leader>l gT
nnoremap <leader>h gt

"---------- Plugin Mappings ----------"

"-- Sayonara --"
nmap <leader>q :Sayonara<cr>

"-- Nerdtree --"
nmap <C-c> :wincmd p<CR>
nmap <C-n> :NERDTreeToggle<CR>:wincmd p<CR>

"-- EasyAlign --"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"-- EasyClip --"
" Remap copy, paste, cut
vmap <C-c> y
vmap <C-v> s
vmap <C-x> m
imap <c-v> <plug>EasyClipInsertModePaste
cmap <c-v> <plug>EasyClipCommandModePaste

"-- FZF and Fugitive --"
nnoremap <silent><C-p> :GFiles<cr>
nnoremap <silent><C-e> :Snippets<cr>
nnoremap <silent><C-f> :Files<CR>
nnoremap <silent><C-a> :Ag<CR>
nnoremap <silent>; :Buffers<CR>
nnoremap <silent>T :Tags<CR>
nnoremap <S-g>l :Commits<CR>
nnoremap <S-g>s :Gstatus<CR>
nnoremap <S-g>d :Gdiff<CR>

"-- Buftabline --"
nnoremap <S-l> :bnext<CR>
nnoremap <S-H> :bprev<CR>

"-- Deoplete and Neosnippets --"
" Tab to accept
inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" : "<Tab>"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
