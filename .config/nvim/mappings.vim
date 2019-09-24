"---------- General Mappings ----------"
" Exit insert and command mode with jk
imap jk <C-c>

" reload .vimrc
nnoremap <leader>v :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>

" Hide last search highlights
nnoremap <silent> <leader><space> :nohlsearch<CR>

" Easy moves through lines (and wrapped ones)
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>

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

"---------- Plugin Mappings ----------"

"-- Sayonara --"
nmap <leader>q :Sayonara<cr>

"-- Nerdtree --"
nmap <C-n> :NERDTreeToggle<CR>
nmap <leader>n :NERDTreeFind<CR>

"-- Commentary --"
nmap // gcc
xmap / <Plug>Commentary

"-- EasyAlign --"
" start interactive EasyAlign for a motion/text object (e.g. <leader>aip)
nmap <leader>a <Plug>(EasyAlign)
xmap <enter> <Plug>(EasyAlign)

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

"-- Clang Formatter --"
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
