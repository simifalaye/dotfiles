" Use ; for commands., do not have to hold shift to do commands
nnoremap ; :
nnoremap , :

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Reload vim configuration file
nnoremap <Leader>rn :source $MYVIMRC<CR>

" Hide last search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Move lines up and down with shift + dir
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Easy moves through wrapped lines
nnoremap j gj
nnoremap k gk

" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" Buf next
nnoremap <C-b> :bun<CR>

" VimSplits remappings
nnoremap <Leader>ts <C-W>s:te<CR>
nnoremap <Leader>tv <C-W>v:te<CR>
nnoremap <Leader>j <C-W><C-J>
nnoremap <Leader>k <C-W><C-K>
nnoremap <Leader>l <C-W><C-L>
nnoremap <Leader>h <C-W><C-H>
set splitbelow
set splitright
"This disables vim split lines
set fillchars=""

" Save file with ctrl + s
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
" Save and quit -> ctrl + a
noremap <silent> <C-A> :wq<CR>
vnoremap <silent> <C-A> <C-C>:wq<CR>
inoremap <silent> <C-A> <C-O>:wq<CR>

" Quit file with Leader + q
" Quit without saving
" Quit all tabs (must be in normal)
nnoremap <leader>q :q<cr>
nnoremap <leader>x :q!<cr>
nnoremap <leader>X :tabdo q<cr>

" fast scrolling
nmap <C-k> 10k
nmap <C-l> 3e
nmap <C-j> 10j
nmap <C-h> 3b


"-- Plugin Mappings --"


" Map leader + g to ack
nnoremap <Leader>g :Ack!<Space>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Bind nn to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>
map <C-f> :NERDTreeFind<cr>

" Remap copy
vmap <C-c> y
" Remap Paste
imap <C-v> <plug>EasyClipInsertModePaste
vmap <C-v> s
" Remap Cut
vmap <C-x> m

" FZF
nnoremap <silent><C-p> :GFiles<cr>
nnoremap <silent><C-e> :FZF<cr>
