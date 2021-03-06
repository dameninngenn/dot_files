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


" Vi互換をオフ
set nocompatible

" neobundle
" 初回起動時はneobundleを手動でとってこないといけない。
" セットアップスクリプトのほうでやるようにしてる
" % mkdir -p ~/.vim/bundle
" % git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'

" github
NeoBundle 'adie/BlockDiff'
NeoBundle 'rhysd/clever-f.vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/googletasks-vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'hotchpotch/perldoc-vim'
NeoBundle 'ikeji/unite-script'
NeoBundle 'houtsnip/vim-emacscommandline'
NeoBundle 'ynkdir/vim-funlib'
NeoBundle 'vim-scripts/phrase.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'dameninngenn/vim-uwaa'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'sukima/xmledit'
NeoBundle 'm4i/YankRingSync'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'dameninngenn/unite-converter-buffer-simple'
NeoBundle 'dameninngenn/unite-perldoc'
NeoBundle 'bling/vim-airline'
NeoBundle 'bling/vim-bufferline'
NeoBundle 'tpope/vim-fugitive'

" github - vim-scripts
NeoBundle 'Align'
NeoBundle 'eregex.vim'
NeoBundle 'YankRing.vim'

filetype plugin indent on

" 環境毎の個別設定読み込み
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

syntax on
filetype plugin on

" コマンドライン補完を拡張モードにする
set wildmenu

" 行番号表示
set number

" filetypeの識別
filetype on

" ステータスライン表示
set laststatus=2
if has('unix') && !has('gui_running')
    inoremap <silent> <ESC> <ESC>
    inoremap <silent> <C-[> <ESC>
endif

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

" 256色
set t_Co=256

" パッケージの::もオートコンプリートできるように
set iskeyword+=:

" コマンド履歴、検索履歴表示コマンド置き換え
nnoremap qqq: <ESC>q:
nnoremap qqq/ <ESC>q/
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" 範囲選択でインデント変更する場合に選択したままにする
vnoremap < <gv
vnoremap > >gv

" 大文字小文字無視
set ignorecase

" 大文字ではじめたら大文字小文字無視しない
set smartcase

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" 大文字小文字を区別しない
let g:neocomplcache_enable_smart_case = 0

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

" ユーザー定義スニペット保存ディレクトリ
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

" 補完を選択しpopupを閉じる
inoremap <expr><C-y> neocomplcache#close_popup()

" 補完をキャンセルしpopupを閉じる
inoremap <expr><C-e> neocomplcache#cancel_popup()

" TABで補完できるようにする
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" 補完候補の共通部分までを補完する
inoremap <expr><C-l> neocomplcache#complete_common_string()

" スニペット
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)

" Include補完の再キャッシュ
map ,nr <ESC>:NeoComplCacheCachingInclude<CR>

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

" ポップアップメニューの色指定
hi Pmenu ctermbg=4
hi PmenuSel ctermbg=8

" perltidy(コード整形)
map ,pt <ESC>:%! perltidy<CR>
map ,ptv <ESC>:'<,'>! perltidy<CR>

" prove(テスト用)
map ,t <ESC>:!prove -v %<CR>
map ,T <ESC>:!prove -v % \| less<CR>

" バッファ移動をspaceとshift + spaceで
noremap <Space> :bnext<CR>
noremap <silent> ,<Space> :bprev<CR>

" Unite.vim
nnoremap <unique> <silent> ,uf :Unite file<CR>
nnoremap <unique> <silent> ,um :Unite file_mru<CR>
nnoremap <unique> <silent> ,ud :Unite directory_mru<CR>
nnoremap <unique> <silent> ,ub :Unite buffer<CR>
nnoremap <unique> <silent> ,ur :Unite register<CR>
nnoremap <unique> <silent> ,us :Unite source<CR>

let g:unite_source_process_enable_confirm = 0
function! s:unite_my_settings()
  " デフォルトのkeymapを入れ替える
  nmap <buffer> Q <Plug>(unite_exit)
  nmap <buffer> q <Plug>(unite_all_exit)
endfunction"}}}
augroup vimrc-unite
  autocmd!
  autocmd FileType unite call s:unite_my_settings()
augroup END

" bufferの表示をファイル名だけに
call unite#custom_source('buffer,buffer_tab', 'filters',
\ ['converters', 'converter_buffer_simple'])

" quickrun
let g:quickrun_config = {
\   '*'   : { 'runmode': 'simple','outputter': 'message' },
\   'perl': { 'command' : 'perl', 'cmdopt': '-MProject::Libs' },
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
nnoremap ,O :<C-u>call append(expand('.'), '')<CR>

" 数値のインクリメントは常に10進数で行う
set nrformats-=octal
set nrformats-=hex

" undo履歴の保持
if version >= 703
  set undofile
  set undodir=~/tmp/
endif

" history
set history=10000

" 行末スペースのハイライト
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" yankringファイル保存PATH
let g:yankring_history_dir = $HOME.'/tmp'

" yankリスト表示
nnoremap <silent> ,yr :YRShow<CR>

" Vimでカーソル下のPerlモジュールを開く
autocmd FileType perl set isfname-=-

" qfixgrep
nnoremap <silent> ,g :Grep 
nnoremap <silent> ,gr :RGrep 
nnoremap <silent> ,gb :BGrep 

" ジャンプ後quickfixを閉じる
let QFix_CloseOnJump = 1

" grepの対象から外す
let MyGrep_ExcludeReg = '[~#]$\|\.o$\|\.obj$\|\.exe$\|[/\\]tags$\|[/\\]\.git[/\\]\|\.swp$'

" vim-uwaa
nnoremap <silent> ,uw :Uwaa normal<CR>

" マッピングを表示
command!
\   -nargs=* -complete=mapping
\   AllMaps
\   map <args> | map! <args> | lmap <args>

"Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" phrase.vim
let mapleader = ","
let g:phrase_ft_tbl = {}
nnoremap <silent> <Leader>pl  :PhraseList<CR>
nnoremap <silent> <Leader>pe  :PhraseEdit<CR>
vnoremap <silent> <Leader>pe  :PhraseEdit<CR>
vnoremap <silent> <Leader>pc  :PhraseCreate<CR>
vnoremap <silent> <Leader>pl  :<C-u>PhraseList<CR>

" If you use Unite plugin
nnoremap <silent> <Leader>up  :<C-u>Unite phrase<CR>

" BlockDiff
vnoremap <silent> <Leader>1  :BlockDiff1<CR>
vnoremap <silent> <Leader>2  :BlockDiff2<CR>

" Unite用スクリプト
nnoremap <silent> <Leader>un :Unite script:perl:~/.vim/unite-scripts/nicoranking.pl<CR>

" w3m
let g:w3m#command = '/usr/bin/w3m'

" http://subtech.g.hatena.ne.jp/motemen/20110817/1313577108
nnoremap <buffer> <silent> ( :<C-U>call PreviewOpenBrace()<CR>
if !exists('*PreviewOpenBrace')
    function PreviewOpenBrace()
        let l:pos = getpos('.')
        if l:pos == get(s:, 'last_pos', [])
            let l:count = s:last_count + 1
        else
            let l:count = v:count1
        endif
        pclose
        pedit
        wincmd p
        execute 'normal!' l:count . '[{'
        setlocal cursorline
        wincmd p
        let s:last_count = l:count
        let s:last_pos   = l:pos
    endfunction
endif

" https://gist.github.com/348915
function! s:package_name()
  let mx = '^\s*package\s\+\([^ ;]\+\)'
  for line in getline(1, 5)
    if line =~ mx
      return substitute(matchstr(line, mx), mx, '\1', '')
    endif
  endfor
  return ""
endfunction

function! s:use_package(name)
  for line in getline(1, 20)
    if line =~ '^use '.a:name.'[; ]'
      return 1
    endif
  endfor
  return 0
endfunction

function! s:validate_package_name()
  let path = expand('%:p:gs!\!/!')
  let name = substitute(s:package_name(), '::', '/', 'g') . '.pm'
  if path[-len(name):] != name && !v:cmdbang
    echohl WarningMsg
    echomsg "A filename is not match as package name, it should be fixd, maybe."
    echohl None
  endif
endfunction

function! s:validate_encoding_utf8()
  if s:use_package('utf8') && &fileencoding != 'utf-8'
    let text = join(getline(1, "$"))
    let all = strlen(text)
    let eng = strlen(substitute(text, '[^\t -~]', '', 'g'))
    if all != eng
      echohl WarningMsg
      echomsg "You use utf8 package, but the file encoding is not utf-8, it should be fixd, maybe."
      echohl None
    endif
  endif
endfunction

au! BufWritePost *.pm call s:validate_package_name()
au! BufWritePost *.pl,*.pm call s:validate_encoding_utf8()

" vim-funlib
function! MD5(data)
  return hashlib#md5(a:data)
endfunction

function! Sha1(data)
  return hashlib#sha1(a:data)
endfunction

function! Sha256(data)
  return hashlib#sha256(a:data)
endfunction

" 忘れがちなショートカットとかをUniteで見れるように
" https://github.com/dameninngenn/unite-source-my-help
nnoremap <silent> ,uh :Unite my_help<CR>

" http://perl-users.jp/articles/advent-calendar/2012/casual/13
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl-script.txt

function! s:pm_template()
    let path = substitute(expand('%'), '.*lib/', '', 'g')
    let path = substitute(path, '[\\/]', '::', 'g')
    let path = substitute(path, '\.pm$', '', 'g')

    call append(0, 'package ' . path . ';')
    call append(1, 'use strict;')
    call append(2, 'use warnings;')
    call append(3, 'use utf8;')
    call append(4, '')
    call append(5, '')
    call append(6, '')
    call append(7, '1;')
    call cursor(6, 0)
    " echomsg path
endfunction
autocmd BufNewFile *.pm call s:pm_template()

function! s:get_package_name()
    let mx = '^\s*package\s\+\([^ ;]\+\)'
    for line in getline(1, 5)
        if line =~ mx
        return substitute(matchstr(line, mx), mx, '\1', '')
        endif
    endfor
    return ""
endfunction

function! s:check_package_name()
    let path = substitute(expand('%:p'), '\\', '/', 'g')
    let name = substitute(s:get_package_name(), '::', '/', 'g') . '.pm'
    if path[-len(name):] != name
        echohl WarningMsg
        echomsg "ぱっけーじめいと、ほぞんされているぱすが、ちがうきがします！"
        echomsg "ちゃんとなおしてください＞＜"
        echohl None
    endif
endfunction
au! BufWritePost *.pm call s:check_package_name()
