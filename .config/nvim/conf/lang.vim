" Syntax highlighting for different languages/filetypes
Plug 'sheerun/vim-polyglot'
  let g:vim_markdown_folding_disabled     = v:true
  let g:vim_markdown_auto_insert_bullets  = v:false
  let g:vim_markdown_new_list_item_indent = v:false
Plug 'kergoth/vim-bitbake'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
  let g:doge_mapping = '<Leader>D'

augroup LangSettings
  au!
  au Filetype gitcommit,markdown setl spell tw=72
augroup end
