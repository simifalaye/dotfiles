" Functions for asyncomplete plugin

" Setup completion sources
function! helpers#asyncomplete#setupSources() abort
  call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'whitelist': ['*'],
      \ 'blacklist': ['go'],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
      \    'max_buffer_size': 5000000,
      \  },
      \ }))
  call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
      \ 'name': 'ultisnips',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
      \ }))
  call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
      \ 'name': 'omni',
      \ 'whitelist': ['*'],
      \ 'blacklist': ['c', 'cpp', 'html'],
      \ 'completor': function('asyncomplete#sources#omni#completor')
      \  }))
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'whitelist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))
endfunction
