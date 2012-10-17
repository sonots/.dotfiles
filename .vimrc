set nocompatible
set nu
set hlsearch
set paste
set nobackup
syntax on
filetype on
filetype indent on
filetype plugin on

" tab indent for ruby
set softtabstop=2
set shiftwidth=2
set expandtab
"set list "visualize tab and return

" search
set history=50
set incsearch
set ignorecase
set smartcase

set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'thinca/vim-ref'
Bundle 'thinca/vim-quickrun'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'
Bundle 'mileszs/ack.vim'
Bundle "git://git.wincent.com/command-t.git"
   
filetype plugin indent on " required!
imap <C-Space> <C-x><C-o>

" ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" ctags
set tags=~/.tags

