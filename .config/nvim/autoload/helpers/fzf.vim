" ==========================
" Functions for fzf plugin
" ==========================

""
" Put list into quickfix
"
" @param {string} lines: lines to put
""
fun! helpers#fzf#build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfun

""
" General fzf configuration from github page
""
fun! helpers#fzf#general()
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
        \ 'ctrl-q': function('helpers#fzf#build_quickfix_list'),
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }
  let g:fzf_layout         = { 'down': '~40%' }
  let g:fzf_buffers_jump   = v:true
  let g:fzf_preview_window = ''
  let g:fzf_history_dir    = '~/.local/share/fzf-history'
endfun

""
" Basic setup
""
fun! helpers#fzf#setup() abort
  " Basic setup
  call helpers#fzf#general()
  " CMD: Find
  if executable('rg')
    let s:grep_cmd = 'rg --column --line-number --no-heading
          \ --fixed-strings
          \ --ignore-case
          \ --hidden
          \ --follow
          \ --glob "!.git/*"
          \ --color "always" '
    command! -bang -nargs=* Find
          \ call fzf#vim#grep(s:grep_cmd . shellescape(<q-args>) . '| tr -d "\017"', 1, <bang>0)
  endif
endfun
