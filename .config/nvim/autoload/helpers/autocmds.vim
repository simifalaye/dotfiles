""
" Toggle relative numbers in Insert/Normal mode.
"
" @param {string} command Command to be executed on toggle.
""
function! helpers#autocmds#togglenumbers(command) abort
  if &l:number && empty(&buftype)
    execute a:command
  endif
endfunction

""
" Jump to last known position and center buffer around cursor.
""
function! helpers#autocmds#jumplast() abort
  if empty(&buftype) && index(['diff', 'gitcommit'], &filetype, 0, v:true) == -1
    if line("'\"") >= 1 && line("'\"") <= line('$')
      execute 'normal! g`"zz'
    endif
  endif
endfunction

""
" Remove trailing whitespace
""
function! helpers#autocmds#stripTrailingWhitespace() abort
  " Don't strip on these filetypes
  if &ft =~ 'ruby\|javascript\|perl\|gitsendemail\|markdown'
    return
  endif
  %s/\s\+$//e
endfun
