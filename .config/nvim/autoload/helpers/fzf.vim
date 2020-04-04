" ==========================
" Functions for fzf plugin
" ==========================

""
" Fzf call Files or GFiles based on if in git dir
""
fun! helpers#fzf#smartFiles(...)
  silent! !git rev-parse --is-inside-work-tree
  if v:shell_error == 0
    return call("fzf#vim#gitfiles", a:000)
  else
    return call("fzf#vim#files", a:000)
  endif
endfun

""
" General fzf configuration from github page
""
fun! helpers#fzf#general()
  let g:fzf_colors       = {
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
  let g:fzf_action       = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit' }
  let g:fzf_layout       = { 'down': '~40%' }
  let g:fzf_buffers_jump = v:true
endfun

""
" Basic setup
""
fun! helpers#fzf#setup() abort
  " CMD: SmartFiles
  command! -bang -nargs=* -complete=dir SmartFiles call helpers#fzf#smartFiles(<q-args>)
  " CMD: Find
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
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
  " CMD: SwitchSess
  command! -bang -nargs=* SwitchSess
        \ call fzf#run({'source': prosession#ListSessions(), 'sink': 'Prosession', 'down': '30%'})

  " Basic setup
  call helpers#fzf#general()
endfun
