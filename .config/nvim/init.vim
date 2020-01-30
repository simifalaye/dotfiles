" Globals
" -------

let mapleader      = " "
let vimhomedir     = has('nvim') ? "~/.config/nvim" : "~/.vim"
let fzfsourcedir   = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"
let vimplugdir     = vimhomedir . "/plugged"
let vimautoloaddir = vimhomedir ."/autoload"
let vimcolordir    = "~/.vimrc_background"

" Disable
" -------

" Disable unused built-in plugins.
let g:loaded_gzip = v:true
let g:loaded_rrhelper = v:true
let g:loaded_tarPlugin = v:true
let g:loaded_zipPlugin = v:true
let g:loaded_netrwPlugin = v:true
let g:loaded_netrwFileHandlers = v:true
let g:loaded_netrwSettings = v:true
let g:loaded_2html_plugin = v:true
let g:loaded_vimballPlugin = v:true
let g:loaded_getscriptPlugin = v:true
let g:loaded_logipat = v:true
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

" Autocommands
" ------------

" Toggle relative numbers in Insert/Normal mode.
augroup togglenumbers
  autocmd!
  autocmd InsertEnter,BufLeave,WinLeave,FocusLost *
        \ call helpers#autocmds#togglenumbers('setlocal norelativenumber')
  autocmd InsertLeave,BufEnter,WinEnter,FocusGained *
        \ call helpers#autocmds#togglenumbers('setlocal relativenumber')
augroup end

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
autocmd Filetype gitcommit,mail,md     setl spell tw=72
autocmd FileType c,cpp                 setl cms=//\ %s
autocmd FileType java                  setl cms=//\ %s sw=2 ts=2
autocmd FileType conf,bitbake,cfg,zsh  setl cms=#\ %s

" Abbreviations (try not to use common words)
" -------------------------------------------

iab tdate <c-r>=strftime("%Y-%m-%d")<cr>
iab todo: @TODO:
iab fixme: @FIXME:

" Source config files
" -------------------

source ~/.config/nvim/settings.vim
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/colors.vim
source ~/.config/nvim/mappings.vim
