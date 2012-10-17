set nocompatible
filetype off
 
set rtp+=~/.vim/vundle.git/
call vundle#rc()
 
" vim-scripts リポジトリ (1)
Bundle "rails.vim"
  
" github の任意のリポジトリ (2)
Bundle "tpope/vim-fugitive"
   
" github 以外のリポジトリ (3)
Bundle "git://git.wincent.com/command-t.git"
   
filetype plugin indent on
