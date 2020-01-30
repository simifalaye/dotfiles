" Functions for vim-lsp plugin

" Setup lsp sources
function! helpers#lsp#setupSources() abort
  if executable('ccls')
     au User lsp_setup call lsp#register_server({
        \ 'name': 'ccls',
        \ 'cmd': {server_info->['ccls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(
        \   lsp#utils#find_nearest_parent_file_directory(
        \     lsp#utils#get_buffer_path(), '.ccls'))},
        \ 'initialization_options': {
        \     'cache': {'directory': expand('~/.cache/ccls')},
        \     'completion': {'detailedLabel': v:false},
        \ },
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        \ })
     autocmd FileType c,cpp,objc,objcpp setlocal omnifunc=lsp#complete
  endif
endfunction
