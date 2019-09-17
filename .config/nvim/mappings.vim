" reload .vimrc
nnoremap <leader>v :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>

" Exit insert and command mode with jk
imap jk <Esc>
imap Jk <Esc>
imap JK <Esc>

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Move lines up and down with shift + dir
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" VimSplits remappings
nnoremap <Leader>ts <C-W>s:te<CR>
nnoremap <Leader>tv <C-W>v:te<CR>
nnoremap <Leader>j <C-W><C-J>
nnoremap <Leader>k <C-W><C-K>
nnoremap <Leader>l <C-W><C-L>
nnoremap <Leader>h <C-W><C-H>
set splitbelow
set splitright
set fillchars=""

" Save file with ctrl + s, save
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR><C-C>
inoremap <silent> <C-S> <C-O>:update<CR><C-O>

" Quit file with Leader + q, Quit without saving, Quit all tabs
nnoremap <leader>q :q<cr>
nnoremap <leader>x :q!<cr>
nnoremap <leader>X :qa!<cr>

" To open a new empty buffer
nmap <leader>tn :enew<cr>
nmap <leader>c :bp <BAR> bd #<CR>
nmap <leader>b :Buffers<CR>
nmap L :bnext<CR>
nmap H :bprevious<CR>

" Tab navigation
nnoremap <leader>l gT
nnoremap <leader>h gt

" Netrw
noremap <silent> <leader>n :call ToggleVExplorer()<CR>

"---------- Plugin Mappings ----------"

"-- EasyAlign --"
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"-- EasyClip --"
" Remap copy, paste, cut
vmap <C-c> y
imap <C-v> <plug>EasyClipInsertModePaste
vmap <C-v> s
vmap <C-x> m

"-- FZF --"
nnoremap <silent><C-p> :GFiles<cr>
nnoremap <silent><C-e> :Snippets<cr>
nnoremap <silent>; :Buffers<CR>
nnoremap <silent>f :Files<CR>
nnoremap <silent>T :Tags<CR>
nnoremap <silent>s :Ag<CR>

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
" Carridge return to jump --"
imap <silent><expr><CR>
          \ pumvisible() ? "\<C-k>" : "<CR>"
