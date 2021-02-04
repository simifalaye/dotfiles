" Vim wrapper for the best/fastest fuzzy finder
Plug 'junegunn/fzf', {'do': './install --all --xdg'}
Plug 'junegunn/fzf.vim'
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
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }
  let g:fzf_layout         = { 'down': '~40%' }
  let g:fzf_buffers_jump   = v:true
  let g:fzf_preview_window = ''
  let g:fzf_history_dir    = '~/.local/share/fzf-history'
  if executable('rg')
    let s:grep_cmd = 'rg --column --line-number --no-heading
          \ --fixed-strings
          \ --ignore-case
          \ --hidden
          \ --follow
          \ --glob "!.git/*"
          \ --color "always" '
    command! -bang -nargs=* Find
          \ call fzf#vim#grep(s:grep_cmd .
          \ shellescape(<q-args>) . '| tr -d "\017"', 1, <bang>0)
  endif

nnoremap <silent><C-p> :Files<CR>
nnoremap <silent><C-f> :Find<CR>
nnoremap <silent>_     :Marks<CR>
nnoremap <silent>,     :Buffers<CR>
