set nocompatible
filetype off
 
set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'rails.vim'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'
Bundle "tpope/vim-fugitive"
Bundle 'vim-ruby/vim-ruby'
Bundle "git://git.wincent.com/command-t.git"
   
filetype plugin indent on " required!

