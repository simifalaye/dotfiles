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
