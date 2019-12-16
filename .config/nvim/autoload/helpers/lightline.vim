function! helpers#lightline#fileModified() abort
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! helpers#lightline#readOnly() abort
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? "RO" : ''
endfunction

function! helpers#lightline#fileName() abort
  return ('' != helpers#lightline#readOnly() ? helpers#lightline#readOnly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != helpers#lightline#fileModified() ? ' ' . helpers#lightline#fileModified() : '')
endfunction

function! helpers#lightline#fileFormat() abort
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! helpers#lightline#fileType() abort
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! helpers#lightline#fileEnc() abort
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! helpers#lightline#mode() abort
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" Fugitive Git integration
function! helpers#lightline#fugitive() abort
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

" Colors
function! helpers#lightline#customColor() abort
  let s:base00 = [ '#181818',  0 ] " black
  let s:base01 = [ '#282828', 18 ]
  let s:base02 = [ '#383838', 19 ]
  let s:base03 = [ '#585858',  8 ]
  let s:base04 = [ '#b8b8b8', 20 ]
  let s:base05 = [ '#d8d8d8',  7 ]
  let s:base06 = [ '#e8e8e8', 21 ]
  let s:base07 = [ '#f8f8f8', 15 ] " white
  let s:base08 = [ '#ab4642',  1 ] " red
  let s:base09 = [ '#dc9656', 16 ] " orange
  let s:base0A = [ '#f7ca88',  3 ] " yellow
  let s:base0B = [ '#a1b56c',  2 ] " green
  let s:base0C = [ '#86c1b9',  6 ] " teal
  let s:base0D = [ '#7cafc2',  4 ] " blue
  let s:base0E = [ '#ba8baf',  5 ] " pink
  let s:base0F = [ '#a16946', 17 ] " brown
  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
  let s:p.normal.left     = [ [ s:base01, s:base0D ], [ s:base05, s:base02 ] ]
  let s:p.insert.left     = [ [ s:base00, s:base0B ], [ s:base05, s:base02 ] ]
  let s:p.visual.left     = [ [ s:base01, s:base09 ], [ s:base05, s:base02 ] ]
  let s:p.replace.left    = [ [ s:base01, s:base08 ], [ s:base05, s:base02 ] ]
  let s:p.inactive.left   = [ [ s:base02, s:base01 ] ]
  let s:p.normal.middle   = [ [ s:base07, s:base00 ] ]
  let s:p.inactive.middle = [ [ s:base00, s:base01 ] ]
  let s:p.normal.right    = [ [ s:base00, s:base03 ], [ s:base06, s:base02 ] ]
  let s:p.inactive.right  = [ [ s:base00, s:base01 ] ]
  let s:p.normal.error    = [ [ s:base07, s:base08 ] ]
  let s:p.normal.warning  = [ [ s:base07, s:base09 ] ]
  let s:p.tabline.left    = [ [ s:base05, s:base02 ] ]
  let s:p.tabline.middle  = [ [ s:base05, s:base00 ] ]
  let s:p.tabline.right   = [ [ s:base05, s:base02 ] ]
  let s:p.tabline.tabsel  = [ [ s:base02, s:base0A ] ]
  " Add theme to lightline
  let g:lightline#colorscheme#base16_sf#palette = lightline#colorscheme#flatten(s:p)
endfunction
