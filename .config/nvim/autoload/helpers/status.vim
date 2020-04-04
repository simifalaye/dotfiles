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
  let l:cur_mode = 'x'
  if a:mode == 'n'
    let l:cur_mode = 'n'
  elseif a:mode == 'i'
    let l:cur_mode = 'i'
  elseif a:mode ==? 'c'
    let l:cur_mode = 'c'
  elseif a:mode ==? 'r'
    let l:cur_mode = 'r'
  else
    let l:cur_mode = 'v'
  endif
  return toupper(l:cur_mode) . ' '
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
