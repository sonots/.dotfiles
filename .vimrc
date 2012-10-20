set nocompatible
set nu
set hlsearch
set nobackup
set clipboard=unnamed,autoselect
syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on " required!

" tab indent for ruby
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

" search
set history=50
set incsearch
set ignorecase
set smartcase

" :e
let g:netrw_liststyle=3 " shows directory tree by e .

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
Bundle 'Sixeight/unite-grep'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/AutoComplPop'
Bundle "git://git.wincent.com/command-t.git"

" ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

" ctags
set tags=~/.tags

"------------------------------------
" unite.vim
"------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=0
" バッファ一覧
noremap <C-U><C-B> :Unite buffer<CR>
" ファイル一覧
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
" 最近使ったファイルの一覧
noremap <C-U><C-R> :Unite file_mru<CR>
" レジスタ一覧
noremap <C-U><C-Y> :Unite -buffer-name=register register<CR>
" ファイルとバッファ
noremap <C-U><C-U> :Unite buffer file_mru<CR>
" 全部
noremap <C-U><C-A> :Unite UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
" Unite-grep
nnoremap <silent> ,ug :Unite grep:%:-iHRn<CR>

" ctrlp.vim
let g:ctrlp_max_height          = &lines " 目一杯に一覧
let g:ctrlp_jump_to_buffer      = 2 " タブで開かれていた場合はそのタブに切り替える
let g:ctrlp_clear_cache_on_exit = 0 " 終了時キャッシュをクリアしない
let g:ctrlp_mruf_max            = 500 " MRUの最大記録数
let g:ctrlp_highlight_match     = [1, 'IncSearch'] " 絞り込みで一致した部分のハイライト
let g:ctrlp_open_new_file       = 1 " 新規ファイル作成時にタブで開く
let g:ctrlp_open_multi          = '10t' " 複数ファイルを開く時にタブで最大10まで開く
let g:ctrlp_prompt_mappings = {
  \ 'PrtBS()':              ['<c-h>', '<bs>', '<c-]>'],
  \ 'PrtDelete()':          ['<del>'],
  \ 'PrtDeleteWord()':      ['<c-w>'],
  \ 'PrtClear()':           ['<c-u>'],
  \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
  \ 'PrtSelectMove("k")':   ['<c-p>', '<up>'],
  \ 'PrtHistory(-1)':       ['<c-k>'],
  \ 'PrtHistory(1)':        ['<c-j>'],
  \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
  \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
  \ 'AcceptSelection("t")': ['<c-t>', '<MiddleMouse>'],
  \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
  \ 'ToggleFocus()':        ['<s-tab>'],
  \ 'ToggleRegex()':        ['<c-r>'],
  \ 'ToggleByFname()':      ['<c-d>'],
  \ 'ToggleType(1)':        ['<c-f>', '<c-up>'],
  \ 'ToggleType(-1)':       ['<c-b>', '<c-down>'],
  \ 'PrtExpandDir()':       ['<tab>'],
  \ 'PrtInsert("w")':       ['<F2>', '<insert>'],
  \ 'PrtInsert("s")':       ['<F3>'],
  \ 'PrtInsert("v")':       ['<F4>'],
  \ 'PrtInsert("+")':       ['<F6>'],
  \ 'PrtCurStart()':        ['<c-a>'],
  \ 'PrtCurEnd()':          ['<c-e>'],
  \ 'PrtCurLeft()':         ['<left>', '<c-^>'],
  \ 'PrtCurRight()':        ['<c-l>', '<right>'],
  \ 'PrtClearCache()':      ['<F5>'],
  \ 'PrtDeleteMRU()':       ['<F7>'],
  \ 'CreateNewFile()':      ['<c-y>'],
  \ 'MarkToOpen()':         ['<c-z>'],
  \ 'OpenMulti()':          ['<c-o>'],
  \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
  \ }

" Save a file by C-s (Normal mode)
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>
" Ctrl-a goes to the beggining of line (Insert mode)
imap <C-a> <esc>0i
" Ctrl-e goes to the end of line (Insert mode)
imap <C-e> <esc>$i<right>
" Go to normal mode from insert mode (Insert mode)
imap <C-i> <C-[>

"------------------------------------
" autocmplpopup
"------------------------------------
" color
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=2
highlight PmenuSel ctermfg=0
"highlight PMenuSbar ctermbg=3
"<TAB>で補完
" Autocompletion using the TAB key
" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function! InsertTabWrapper()
        let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
                return "\<TAB>"
        else
                if pumvisible()
                        return "\<C-N>"
                else
                        return "\<C-N>\<C-P>"
                end
        endif
endfunction
" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" Do not feed line by return
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
