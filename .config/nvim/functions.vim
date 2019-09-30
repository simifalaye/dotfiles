" Company syntastic setup
" -----------------------

" Sets up the standard include directories based on your current working directory
function! SyntasticSETUP()
  let makedir = fnamemodify(findfile("Makefile", ",;"), ":.:h")
  let include_dirs = split(substitute(substitute(system("cd " . shellescape(makedir) . " ; make debug_print | grep \'INC_DIRS:\'"), "INC_DIRS:", "", "g"), " *-I", " ", "g"))
  let include_dirs = filter(include_dirs, 'v:val =~ "^\/"')
  call add(include_dirs, makedir)
  call add(include_dirs, makedir . "/../include")
  let g:syntastic_c_include_dirs = include_dirs
  let b:syntastic_c_cflags = ' -DLINUXPC -DDEV_PC -D_GNU_SOURCE -Wall -Werror -Wextra'
endfunction

" Gets vim-plug
" -------------

function! GetVimPlug(dir)
  if empty(glob(a:dir . '/plug.vim')) && executable('curl')
    execute 'silent !curl -fLo ' . a:dir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

" Various lightline functions
" ---------------------------

function! LightlineFugitive()
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '@' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
