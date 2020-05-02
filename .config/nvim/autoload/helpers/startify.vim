" ===============================
" Functions for startify plugin
" ===============================

""
" List local commits
""
function! helpers#startify#listcommits()
  let git = 'git'
  let commits = systemlist(git . ' log --oneline | head -n5')
  let git = 'G' . git[1:]
  return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'.
        \ git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

""
" Basic setup
""
fun! helpers#startify#setup() abort
  let g:startify_change_to_vcs_root  = v:true
  let g:startify_enable_special      = v:false
  let g:startify_files_number        = 5
  let g:startify_relative_path       = v:true
  let g:startify_update_oldfiles     = v:true
  let g:startify_session_autoload    = v:true
  let g:startify_session_dir         = g:sessiondir
  let g:startify_session_persistence = v:true
  let g:startify_bookmarks           = [
        \ {'n': '~/.config/nvim/init.vim'},
        \ {'z': '~/.config/zsh/.zshrc'},
        \ {'s': '~/.config/shell/shell-profile'}
        \ ]
  " Custom startup list, only show MRU from current directory/project
  let g:startify_lists = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': function('helpers#startify#listcommits'), 'header': [ 'Recent Commits' ] },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]
  let g:startify_commands = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]
endfun
