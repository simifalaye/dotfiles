" Welcome page/session handler for vim
Plug 'mhinz/vim-startify'
  let g:startify_change_to_dir       = v:false
  let g:startify_enable_special      = v:false
  let g:startify_relative_path       = v:true
  let g:startify_update_oldfiles     = v:true
  let g:startify_session_dir         = g:vimhomedir . "/session"
  let g:startify_session_persistence = v:true
  let g:startify_bookmarks           = [
        \ {'s': '~/.config/shell/interactive'},
        \ {'v': '~/.config/nvim/init.vim'},
        \ {'z': '~/.config/zsh/.zshrc'}
        \ ]
  let g:startify_lists               = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]
  let g:startify_commands            = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]

nnoremap <leader>h :Startify<CR>
