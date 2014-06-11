"------------------------------------
" Vundle
"------------------------------------
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/')) " this makes `syntax off`! sucks!

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Sixeight/unite-grep'
"NeoBundle 'kien/ctrlp.vim'
NeoBundle 'sonots/ctrlp.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'scrooloose/nerdtree'
" ruby
NeoBundle 'mileszs/ack.vim'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-rake'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'vim-ruby/vim-ruby'
"NeoBundle 'vim-scripts/YankRing.vim'
"NeoBundle 'jnwhiteh/vim-golang'
"NeoBundle 'Blackrush/vim-gocode'

"------------------------------------
" Vim
"------------------------------------
" No vi compatibility
set nocompatible
" 行数を表示
set number
" ~ファイルを作らない
set nobackup
" swpファイルを作らない
set noswapfile
" スクロール時の余白確保
set scrolloff=10
" No beep sound
set visualbell t_vb=
" 前行へのバックスペース許可など
set backspace=indent,eol,start
" Copy to clipboard. NOTE: You need reattach-to-user-namespace on tmux on Mac.
" See http://qiita.com/yuku_t/items/bea95b1bc6e6ca8a495b
set clipboard+=unnamed
" Make a copy by selection like X
set clipboard+=autoselect
set hidden
syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on " required for NeoBundle

"------------------------------------
" Buffer
"------------------------------------
" バッファ切り替え
nmap ,n :<C-U>bnext<CR>
nmap ,p :<C-U>bprevious<CR>
nnoremap ,1   :e #1<CR>
nnoremap ,2   :e #2<CR>
nnoremap ,3   :e #3<CR>
nnoremap ,4   :e #4<CR>
nnoremap ,5   :e #5<CR>
nnoremap ,6   :e #6<CR>
nnoremap ,7   :e #7<CR>
nnoremap ,8   :e #8<CR>
nnoremap ,9   :e #9<CR>
" バッファ一覧
nmap ,b :buffers<CR>

"------------------------------------
" status bar
"------------------------------------
set ruler
set cmdheight=1
set title
set linespace=0
set wildmenu
set showcmd
"set textwidth=78
"set columns=100
"set lines=150
" バッファタブにパスを省略してファイル名のみ表示する
let g:buftabs_only_basename=1
" バッファタブをステータスライン内に表示する
let g:buftabs_in_statusline=1
" 現在のバッファをハイライト
let g:buftabs_active_highlight_group="Visual"
" ステータスライン
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\[%04l,%04v][%02p%%]
" ステータスラインを常に表示
set laststatus=2
" No paren match
let loaded_matchparen = 1

"------------------------------------
" Highlight the current line of the active buffer
"------------------------------------
" This made cursor move slow. I disable this.
"augroup vimrc_set_cursorline_only_active_window
"  autocmd!
"  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline
"  autocmd WinLeave * setlocal nocursorline
"augroup END

"------------------------------------
" indent
"------------------------------------
" Tab 文字を空白文字に置き換える (:set noet to off)
set expandtab
" Tab 入力時に挿入する空白文字の数
set softtabstop=2
" Indent 時に挿入する空白文字の数
set shiftwidth=2
" Tab 文字の見た目上の幅
set tabstop=2
" 改行時にオートインデント
set autoindent
" スマートインデント
set smartindent

autocmd Syntax perl set softtabstop=4 | set shiftwidth=4 | set tabstop=4
autocmd Syntax ruby set softtabstop=2 | set shiftwidth=2 | set tabstop=2
autocmd Syntax javascript set softtabstop=2 | set shiftwidth=2 | set tabstop=2
autocmd Syntax yaml set softtabstop=2 | set shiftwidth=2 | set tabstop=2
autocmd BufNewFile,BufRead *.tt set softtabstop=2 | set shiftwidth=2 | set tabstop=2
autocmd Syntax html,xhtml set softtabstop=2 | set shiftwidth=2 | set tabstop=2
autocmd BufNewFile,BufReadPost *.go set filetype=go
autocmd FileType go setlocal noexpandtab tabstop=2 shiftwidth=2

"------------------------------------
" search
"------------------------------------
" highlight all search matches
set hlsearch
set history=50
set incsearch
"set ignorecase
set smartcase

" :e
let g:netrw_liststyle=3 " shows directory tree by e .

" ctags
set tags=.tags

""------------------------------------
"" vim-colors-solarized
""------------------------------------
"Bundle "altercation/vim-colors-solarized"
"syntax enable
"set background=dark
"colorscheme solarized
"let g:solarized_termcolors=256

"------------------------------------
" vim-ruby
"------------------------------------
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

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

"------------------------------------
" ctrlp.vim
"------------------------------------
set runtimepath^=~/.vim/bundle/ctrlp.vim
" let g:ctrlp_max_height          = &lines " 目一杯に一覧
let g:ctrlp_max_height          = 10 " 10行
let g:ctrlp_jump_to_buffer      = 2 " タブで開かれていた場合はそのタブに切り替える
let g:ctrlp_clear_cache_on_exit = 1 " 終了時キャッシュをクリアする
let g:ctrlp_mruf_max            = 500 " MRUの最大記録数
"let g:ctrlp_highlight_match     = [1, 'IncSearch'] " 絞り込みで一致した部分のハイライト
let g:ctrlp_open_new_file       = 1 " 新規ファイル作成時にタブで開く
let g:ctrlp_open_multi          = '10t' " 複数ファイルを開く時にタブで最大10まで開く
let g:ctrlp_match_window_reversed = 0 " Change the listing order of the files in the match window.
let g:ctrlp_mruf_default_order = 0 " Set this to 1 to disable sorting when searching in MRU mode:
let g:ctrlp_map = '<c-p>' " Start CtrlP by Ctrl-p
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_prompt_mappings = {
  \ 'PrtBS()':              ['<c-h>', '<bs>', '<c-]>'],
  \ 'PrtDelete()':          ['<del>'],
  \ 'PrtDeleteWord()':      ['<c-w>'],
  \ 'PrtClear()':           ['<c-u>'],
  \ 'PrtSelectMove("j")':   ['<c-n>', '<c-j>', '<down>'],
  \ 'PrtSelectMove("k")':   ['<c-p>', '<c-k>', '<up>'],
  \ 'PrtHistory(-1)':       [],
  \ 'PrtHistory(1)':        [],
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

" RSense (Get rsense.vim)
"let g:rsenseHome = $HOME . "/opt/rsense"
"setlocal completefunc=RSenseComplete

"------------------------------------
" neocmplcache
"------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
"imap <C-k>     <Plug>(neocomplcache_snippets_expand)
"smap <C-k>     <Plug>(neocomplcache_snippets_expand)
"inoremap <expr><C-g>     neocomplcache#undo_completion()
"inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Custom key-mappings
inoremap <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
"inoremap <expr><C-[>  pumvisible() ? neocomplcache#cancel_popup() : "\<ESC>"

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplcache_omni_patterns')
"  let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
"let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" Popup color
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PmenuSbar ctermbg=4

"------------------------------------
" Insert mode like emacs
"------------------------------------
""inoremap <tab> <C-o>==<End> " Use <tab> to indent
"inoremap <C-p> <Up>
"inoremap <C-n> <Down>
"inoremap <C-b> <Left>
"inoremap <C-f> <Right>
"inoremap <C-e> <End>
"inoremap <C-a> <Home>
"inoremap <C-h> <Backspace>
"inoremap <C-d> <Del>
"" カーソル位置の行をウィンドウの中央に来るようにスルロール
"inoremap <C-l> <C-o>zz
"" カーソル以降の文字を削除
"inoremap <C-k> <C-o>D
"" カーソル以前の文字を削除
"inoremap <C-u> <C-o>d0
"" アンドゥ
"inoremap <C-x>u <C-o>u
"" 貼りつけ
"inoremap <C-y> <C-o>P
"" カーソルから単語末尾まで削除
"inoremap <F1>d <C-o>dw
"" ファイルの先頭に移動
"inoremap <F1>< <Esc>ggI
"" ファイルの末尾に移動
"inoremap <F1>> <Esc>GA
"" 下にスクロール
"inoremap <C-v> <C-o><C-f>
"" 上にスクロール
"inoremap <F1>v <C-o><C-b>
"" Ctrl-Space で補完
"" Windowsは <Nul>でなく <C-Space> とする
"inoremap <Nul> <C-n>
"" 保存

"------------------------------------
" Command-line mode keymappings like emacs
"------------------------------------
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
"}}}

"------------------------------------
" SkeltonAu
"------------------------------------
inoremap <C-x>s <Esc>:w<CR>a
inoremap <C-x>c <Esc>:wq<CR>
augroup SkeletonAu
    autocmd!
    autocmd BufNewFile *.pl 0r $HOME/.dotfiles/.vim/skel/skel.pl
    autocmd BufNewFile *.pm 0r $HOME/.dotfiles/.vim/skel/skel.pm
    autocmd BufNewFile 00-compile.t 0r $HOME/.dotfiles/.vim/skel/skel_00-compile.t
    autocmd BufNewFile 01-call_func.t 0r $HOME/.dotfiles/.vim/skel/skel_01-call_func.t
    autocmd BufNewFile \%(00-compile\|01\-call_func)\@!*.t 0r $HOME/.dotfiles/.vim/skel/skel.t
    autocmd BufNewFile Gemfile 0r $HOME/.dotfiles/.vim/skel/Gemfile
    autocmd BufNewFile *.gemspec 0r $HOME/.dotfiles/.vim/skel/skel.gemspec
augroup END

"------------------------------------
" NERD Tree
"------------------------------------
" Ctrl-n でトグル
noremap <C-n> :NERDTreeToggle<CR>

"------------------------------------
" Shorten split window move
"------------------------------------
" C-w h ではなく C-h だけで、左の split ウィンドウに移動できるように
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j

"------------------------------------
" Additional Hotkeys
"------------------------------------
" C-n: Syntax check for a perl/ruby script
" C-e: Execute a perl/ruby script
autocmd FileType perl :map <C-n> <ESC>:!perl -cw %<CR>
autocmd FileType perl :map <C-e> <ESC>:!perl %<CR>
autocmd FileType ruby :map <C-n> <ESC>:!ruby -cW %<CR>
autocmd FileType ruby :map <C-e> <ESC>:!ruby %<CR>
" Exit insert mode with C-j
imap <C-j> <C-[>

" vimgrep後にcwinを表示
autocmd QuickFixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
" alias grep to vimgrep
set grepprg=internal



