" Globals
" -------

let mapleader      = " "
let vimhomedir     = has('nvim') ? "~/.config/nvim" : "~/.vim"
let fzfsourcedir   = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"
let vimplugdir     = vimhomedir . "/plugged"
let vimautoloaddir = vimhomedir ."/autoload"

" Disable
" -------

" Disable unused built-in plugins.
let g:loaded_gzip              = v:true
let g:loaded_rrhelper          = v:true
let g:loaded_tarPlugin         = v:true
let g:loaded_zipPlugin         = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_netrwFileHandlers = v:true
let g:loaded_netrwSettings     = v:true
let g:loaded_2html_plugin      = v:true
let g:loaded_vimballPlugin     = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_logipat           = v:true
let g:loaded_tutor_mode_plugin = v:true

" Disable copy for cut actions
nnoremap c "_c
xnoremap c "_c
nnoremap cc "_S
nnoremap C "_C
xnoremap C "_C
nnoremap d "_d
xnoremap d "_d
nnoremap dd "_dd
nnoremap D "_D
xnoremap p "_dP

" Source config files
" -------------------

source ~/.config/nvim/settings.vim
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/mappings.vim
source ~/.config/nvim/colors.vim

" Autocommands
" ------------

" Toggle cursorline
augroup CursorLine
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END
" Jump to last known position and center buffer around cursor.
augroup jumplast
  autocmd!
  autocmd BufWinEnter ?* call helpers#autocmds#jumplast()
augroup end
" Remove trailing whitespace on save
augroup trailingwhitespace
  autocmd!
  autocmd BufWritePre * call helpers#autocmds#stripTrailingWhitespace()
augroup end
" File type settings
augroup filetypesettings
  autocmd!
  autocmd FileType markdown          let b:indentLine_enabled = 0
  autocmd Filetype gitcommit,mail,md setl spell        tw=72
  autocmd FileType c,cpp             setl shiftwidth=4 tabstop=4 commentstring=//\ %s
  autocmd FileType java              setl shiftwidth=2 tabstop=2 commentstring=//\ %s
  autocmd FileType vim               setl shiftwidth=2 tabstop=2
  autocmd FileType sh,zsh            setl shiftwidth=4 tabstop=4
augroup end
