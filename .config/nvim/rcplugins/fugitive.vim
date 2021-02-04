" Git wrapper for vim
Plug 'tpope/vim-fugitive', {'on': [ 'Gstatus', 'Gblame', 'Gdiff' ]}

nnoremap <silent> gid :Gdiff<CR>
nnoremap <silent> gis :Gstatus<CR>
