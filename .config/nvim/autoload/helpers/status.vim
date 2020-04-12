" ======================
" StatusLine Functions
" ======================

""
" Get mode str
"
" @param {string} mode: Current editing mode
"
" @return {string} mode string
""
fun! helpers#status#mode(mode)
  let l:currentmode={
        \ 'n'  : 'N ',
        \ 'no' : 'NO',
        \ 'v'  : 'V ',
        \ 'V'  : 'V ',
        \ ''  : 'V ',
        \ '' : 'V ',
        \ 's'  : 'S ',
        \ 'S'  : 'S ',
        \ '' : 'S ',
        \ 'i'  : 'I ',
        \ 'R'  : 'R ',
        \ 'Rv' : 'V ',
        \ 'c'  : 'C ',
        \ 'cv' : 'V EX ',
        \ 'ce' : 'E ',
        \ 'r'  : 'P ',
        \ 'rm' : 'M ',
        \ 'r?' : 'C ',
        \ '!'  : 'S ',
        \ 't'  : 'T '}
  return l:currentmode[a:mode]
endfun

""
" Get readonly status
"
" @return {string} readonly status string
""
fun! helpers#status#readOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfun

""
" Get git branch
"
" @return {string} branch name
""
fun! helpers#status#gitBranch()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
endfun
