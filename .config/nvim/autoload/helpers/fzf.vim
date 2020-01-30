" Functions for fzf plugin

" Fzf call Files or GFiles based on if in git dir
function! helpers#fzf#smartFiles(...)
  silent! !git rev-parse --is-inside-work-tree
  if v:shell_error == 0
    return call("fzf#vim#gitfiles", a:000)
  else
    return call("fzf#vim#files", a:000)
  endif
endfunction

" Setup completion sources
function! helpers#fzf#setupCommands() abort
  " CMD: SmartFiles
  command! -bang -nargs=* -complete=dir SmartFiles call helpers#fzf#smartFiles(<q-args>)

  " C D: Find
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
  endif
endfunction
