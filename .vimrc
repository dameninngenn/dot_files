" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
 " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

syntax on
filetype plugin on

" Vi互換をオフ
set nocompatible

" コマンドライン補完を拡張モードにする
set wildmenu

" 行番号表示
set number

" filetypeの識別
filetype on

" ステータスライン表示
set laststatus=2
set statusline=
set statusline+=%=\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c%V%8P

" 行番号とか右下に出す
set ruler

" カーソル行にルーラー
set cursorline

" jkでのカーソルを表示行単位で移動可能に
noremap j gj
noremap k gk

" オートインデントを有効にする
set autoindent

" 高度なインデント
set smartindent

" backspaceで行頭の空白,改行,insert時の手前文字削除可能
set backspace=indent,eol,start

" 検索結果文字列のハイライトを有効にする
set hlsearch

" Tab文字の可視化
set list
set listchars=tab:>\ 

" タブが対応する空白の数
set tabstop=4

" y,pでクリップボードを操作できる
set clipboard+=unnamed

" バッファを切替えてもundoの効力を失わない
set hidden

" 入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

" 全角スペースを視覚化(SJIS only)
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

" タブをスペースに変換する
set expandtab

" タブやバックスペースの使用等の編集操作をするときに、タブが対応する空白の数
set softtabstop=4

" インデントの各段階に使われる空白の数
set shiftwidth=4

" teraterm でもカラー表示出来るように
set term=builtin_linux
set ttytype=builtin_linux

" 色設定
colorscheme darkblue

" パッケージの::もオートコンプリートできるように
set iskeyword+=:

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" 大文字小文字を区別する
let g:neocomplcache_enable_smart_case = 1

" キャメルケース補完を有効にする
let g:neocomplcache_enable_camel_case_completion = 1

" アンダーバー補完を有効にする
let g:neocomplcache_enable_underbar_completion = 1

" シンタックスファイルの補完対象キーワードとする最小の長さ
let g:neocomplcache_min_syntax_length = 3 

" プラグイン毎の補完関数を呼び出す文字数
let g:neocomplcache_plugin_completion_length = {
  \ 'keyword_complete'  : 2,
  \ 'syntax_complete'   : 2
  \ }

" ファイルタイプ毎の辞書ファイルの場所
let g:neocomplcache_dictionary_filetype_lists = { 
  \ 'default' : '',
  \ 'perl' : $HOME.'/.vim/dict/perl.dict',
  \ } 

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif

" 補完を選択しpopupを閉じる
inoremap <expr><C-y> neocomplcache#close_popup()

" 補完をキャンセルしpopupを閉じる
inoremap <expr><C-e> neocomplcache#cancel_popup()

" TABで補完できるようにする
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" 補完候補の共通部分までを補完する
inoremap <expr><C-l> neocomplcache#complete_common_string()

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

" perltidy(コード整形)
map ,pt <ESC>:%! perltidy<CR>
map ,ptv <ESC>:'<,'>! perltidy<CR>

" prove(テスト用)
map ,t <ESC>:!prove -v %<CR>
map ,T <ESC>:!prove -v % \| less<CR>

" perlスクリプトとして実行
map ,pe <ESC>:!perl %<CR>
map ,PE <ESC>:!perl % \| less<CR>

" buftabs設定
" バッファタブにパスを省略してファイル名のみ表示する(buftabs.vim)
let g:buftabs_only_basename=1

" バッファの表示をステータスラインに
let g:buftabs_in_statusline=1

" 選択中のバッファをハイライト
let g:buftabs_active_highlight_group="Visual"

" バッファ移動をspaceとshift + spaceで
noremap <Space> :bnext<CR>
noremap <S-Space> :bprev<CR>

" FuzzyFinder(あいまい検索)
nnoremap <unique> <silent> ,fb :FufBuffer!<CR>
nnoremap <unique> <silent> ,ff :FufFile!<CR>
nnoremap <unique> <silent> ,fd :FufDir!<CR>
nnoremap <unique> <silent> ,fm :FufMruFile!<CR>
nnoremap <unique> <silent> ,fc :FufRenewCache<CR>
autocmd FileType fuf nmap <C-c> <ESC>
let g:fuf_patternSeparator = ' '
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_mrufile_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'
let g:fuf_mrufile_maxItem = 100
let g:fuf_enumeratingLimit = 20
let g:fuf_file_exclude = '\v\.DS_Store|\.git|\.swp|\.svn'

" quickrun(\r)の出力先をウィンドウではなく!実行と同じに変更
let g:quickrun_config = {
\   '*': {'runmode': 'simple','output': '!'},
\ }

" 拡張子の関連付け
autocmd BufNewFile,BufRead *.wl set filetype=perl

" バッファ削除
nmap <silent> ,d :bdelete<CR>
nmap <silent> ,D :bdelete!<CR>

" 改行は削除せず1行削除
nnoremap <silent> ,a :S/^.*$//<CR>

" 空行を挿入
nnoremap ,o :<C-u>call append(expand('.'), '')<CR>j

" 数値のインクリメントは常に10進数で行う
set nrformats-=octal
set nrformats-=hex

" NERD_tree
" トグル
nnoremap <silent> ,ntt :NERDTreeToggle<CR>

" 現在表示しているファイルのディレクトリを表示
nnoremap <silent> ,ntd  :NERDTree <C-R>=expand("%:p:h")<CR><CR>

" 隠しファイルの表示ON
let NERDTreeShowHidden = 1

" Taglist(use exctags)
nnoremap <silent> ,tl :Tlist<CR>
set tags=tags,./tags,../tags

" yankringファイル保存PATH
let g:yankring_history_dir = $HOME.'/tmp'


"======================================================================
" For Perl
"======================================================================
"if has('autocmd')
"    augroup EditPerl
"        autocmd!
"        autocmd! BufRead,BufNewFile *.cgi set filetype=perl
"        autocmd! BufRead,BufNewFile *.tdy set filetype=perl
"        autocmd FileType perl set expandtab
"        autocmd FileType perl set smarttab
        " Vimでカーソル下のPerlモジュールを開く
        " http://d.hatena.ne.jp/spiritloose/20060817/1155808744
"        autocmd FileType perl set isfname-=-
        " bonnu
"        autocmd BufWritePost,FileWritePost *.p[lm] !perl -MFindBin::libs -wc <afile>
"    augroup END
"endif

" perl-support.vim
"let g:Perl_PerlcriticSeverity = 1

