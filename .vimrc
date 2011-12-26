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
set statusline+=%=\ %{g:HahHah()}\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c%V%8P

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

" pathogen.vim
call pathogen#runtime_append_all_bundles()

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

" buftabs設定
" バッファタブにパスを省略してファイル名のみ表示する(buftabs.vim)
let g:buftabs_only_basename=1

" バッファの表示をステータスラインに
let g:buftabs_in_statusline=1

" 選択中のバッファをハイライト
let g:buftabs_active_highlight_group="Visual"

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

" ハイライトの指定
let g:unite_abbr_highlight = 'Pmenu'

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
nnoremap ,O :<C-u>call append(expand('.'), '')<CR>

" 数値のインクリメントは常に10進数で行う
set nrformats-=octal
set nrformats-=hex

" undo履歴の保持
if version >= 703
  set undofile
  set undodir=~/tmp/
endif

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

" 環境毎の個別設定読み込み
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

