" Status Item: file modified
function! helpers#lightline#fileModified() abort
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

" Status Item: read only status
function! helpers#lightline#readOnly() abort
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? "RO" : ''
endfunction

" Status Item: name of file
function! helpers#lightline#fileName() abort
  return ('' != helpers#lightline#readOnly() ? helpers#lightline#readOnly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != helpers#lightline#fileModified() ? ' ' . helpers#lightline#fileModified() : '')
endfunction

" Status Item: format of file
function! helpers#lightline#fileFormat() abort
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

" Status Item: type of file
function! helpers#lightline#fileType() abort
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

" Status Item: file encoding
function! helpers#lightline#fileEnc() abort
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

" Status Item: vim mode
function! helpers#lightline#mode() abort
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" Status Item: vim fugitive git integration
function! helpers#lightline#fugitive() abort
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

" Remove the background color from the status/tab line
function helpers#lightline#floating() abort
  let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
  let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
  let s:palette.inactive.middle = s:palette.normal.middle
  let s:palette.tabline.middle = s:palette.normal.middle
endfunction
