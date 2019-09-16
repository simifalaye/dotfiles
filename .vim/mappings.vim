" reload .vimrc
nnoremap <leader>v :so $MYVIMRC<cr>:echo ".vimrc reloaded"<cr>

" Exit insert and command mode with jk
imap jk <Esc>
imap Jk <Esc>
imap JK <Esc>

" quick tab navigation
nnoremap H gT
nnoremap L gt

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

" Save file with ctrl + s, save and quit with ctrl + a
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR><C-C>
inoremap <silent> <C-S> <C-O>:update<CR><C-O>
noremap <silent> <C-A> :wq<CR>
vnoremap <silent> <C-A> <C-C>:wq<CR>
inoremap <silent> <C-A> <C-O>:wq<CR>

" Quit file with Leader + q, Quit without saving, Quit all tabs
nnoremap <leader>q :q<cr>
nnoremap <leader>x :q!<cr>
nnoremap <leader>X :qa!<cr>

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>tn :enew<cr>
" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
nmap <leader>h :bprevious<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>c :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>b :Buffers<CR>

" Netrw
noremap <silent> <leader>n :call ToggleVExplorer()<CR>

"-- Plugin Mappings --"


" Map leader + g to ack
nnoremap <Leader>g :Ack!<Space>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Remap copy, paste, cut
vmap <C-c> y
imap <C-v> <plug>EasyClipInsertModePaste
vmap <C-v> s
vmap <C-x> m

" FZF
nnoremap <silent><C-p> :GFiles<cr>
nnoremap <silent><C-e> :Snippets<cr>
nnoremap <silent>; :Buffers<CR>
nnoremap <silent>f :Files<CR>
nnoremap <silent>T :Tags<CR>
nnoremap <silent>s :Ag<CR>
