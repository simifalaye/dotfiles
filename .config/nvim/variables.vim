" Globals
" -------
" Variables that will be used in the whole vim config

" Use leader to specify extra keybinding
let mapleader = " "

" Get useful env variables if set
let vimhomedir = !empty($VIM_HOME_DIR) ? $VIM_HOME_DIR : "~/.vim"
let fzfsourcedir = !empty($FZF_SOURCE_DIR) ? $FZF_SOURCE_DIR : "~/.fzf"

" Set directory variables
let vimplugdir=vimhomedir . "/plugged"
let vimautoloaddir= ($EDITOR == "nvim") ?
            \ $HOME . "/.local/share/nvim/site/autoload" : vimhomedir . "/autoload"
let vimundodir=vimhomedir . "/undodir"
