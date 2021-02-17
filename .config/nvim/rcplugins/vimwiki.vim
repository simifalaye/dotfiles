" Personal wiki inside of vim in plain-text files
Plug 'vimwiki/vimwiki'
  let g:vimwiki_global_ext = 0
  let g:vimwiki_list = [{
    \ 'path': '~/Dropbox/notes', 'name': 'My Knowledge Base',
    \ 'syntax': 'markdown', 'ext': '.md',
    \ 'links_space_char': '_',
    \ 'auto_toc': 1,
    \ 'auto_generate_links': 1,
    \ 'auto_diary_index': 1,
    \ 'diary_rel_path': '/_logs',
    \ 'diary_index': 'logs',
    \ 'diary_header': 'Logs',
    \ 'diary_caption_level': -1,
    \ }]

set nocompatible
filetype plugin on
syntax on
" Don't use vimwiki builtin markdown syntax
au FileType vimwiki set filetype=vimwiki.markdown
" Tab needed for completion
au filetype vimwiki silent! iunmap <buffer> <Tab>
