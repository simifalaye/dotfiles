" Vim wrapper for the best/fastest fuzzy finder
Plug 'junegunn/fzf', {'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction
  let g:fzf_colors         = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }
  let g:fzf_action         = {
        \ 'ctrl-q': function('s:build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }
  let g:fzf_buffers_jump   = v:true
  let g:fzf_preview_window = ['right:50%', 'ctrl-/']
  let g:fzf_history_dir    = '~/.local/share/fzf-history'

nnoremap <silent><C-p> :Files<CR>
nnoremap <silent><C-f> :Rg<CR>
nnoremap <silent>-     :Buffers<CR>
nnoremap <silent>_     :Marks<CR>
