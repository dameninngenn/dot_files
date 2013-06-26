# 言語設定
export LANG=ja_JP.UTF-8 

# emacsバインド
bindkey -e

# mailcheck off
export MAILCHECK=0

# umask
umask 022

# BSD用lsのカラー設定
export LSCOLORS=exfxbxdxcxegedabagacad

# OSによってlsオプションを分ける
case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G"
    ;;
linux*)
    alias ls="ls --color"
    export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
    ;;
cygwin*)
    export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
    alias ls="ls --show-control-chars --color=auto"
    ;;
esac

# PAGER
export PAGER='less -R'

# grep
export GREP_OPTIONS='--color=auto'

# alias
setopt complete_aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -lh'
alias vi='vim'
alias em='emacs'
alias h='history -E -32'
alias vizsh='vi ~/.zshrc; source ~/.zshrc'
alias vivimrc='vi ~/.vimrc'
alias viemacs='vi ~/.emacs'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gl='git log --color'
alias gd='git diff --color'

alias unko='echo "　/＼＿________＿_／＼";
echo "／　⌒　　 　　⌒ ::: ＼";
echo "| （●）,　、（●）、　| 　　 ／￣￣￣￣￣";
echo "|　,,ノ(、_, )ヽ、,, 　|  　＜　やるじゃん";
echo "|　　ト‐＝‐ｧ 　 .::::| 　　 ＼＿＿＿＿＿";
echo "＼　　｀ニニ´　  .:::／";
echo "／｀ー‐--‐‐- ―´´＼"'
alias l='unko; unko; unko; unko'

alias ippei='curl https://raw.github.com/gist/5865715/timer.pl | perl - --color=green'

# history設定
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups
setopt share_history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# zsh補完機能
autoload -U compinit
compinit

# lsの配色と補完候補の配色を合わせる
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=32' 'bd=46;34' 'cd=43;34'

# 大文字小文字の区別をせずに補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# tab補完で選択できるようにする
zstyle ':completion:*:default' menu select

# プロンプト設定
setopt prompt_subst
autoload colors
colors

# 左pormptにbranchの表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '(%s-%b)'
zstyle ':vcs_info:*' actionformats '(%s-%b|%a)'

precmd_vcs_info () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
typeset -ga precmd_functions
precmd_functions+=precmd_vcs_info

# perlbrewで切り替えたperlバージョンの表示
precmd_perl_v () {
    [[ -n "${PERLBREW_PERL}" ]] && psvar[2]="${PERLBREW_PERL}"
}
precmd_functions+=precmd_perl_v

# z.sh
if [ -f $HOME/local/bin/z.sh ]; then
    _Z_CMD=j
    source $HOME/local/bin/z.sh
    precmd_z () {
        _z --add "$(pwd -P)"
    }
    precmd_functions+=precmd_z
fi

# prompt表示設定
PROMPT="%B%1(v|%{[32;40m%}%1v%{[m%}|)%b%B%{[35;40m%}[orz %c/]%%%{[m%}%b%{$reset_color%} "
PROMPT2="%{[35;40m%}%_%%%{[m%}%{$reset_color%} "
SPROMPT="%{[35;40m%}%r is correct? [n,y,a,e]:%{[m%}%{$reset_color%} "
RPROMPT="%{[36;40m%}[%~]%{m%}%2(v|%B%{[31;40m%}(%2v)%{[m%}|)%{${reset_color}%}"

# コマンド入力後右プロンプト消す
setopt transient_rprompt

# TABで変換候補切り替え
setopt auto_menu

# cdコマンド無しでディレクトリ移動
setopt auto_cd

# cd - でディレクトリ移動可能
setopt auto_pushd

# cd - 候補かぶってるのは無視する
setopt pushd_ignore_dups

# コマンドチェック
setopt correct

# 候補を詰めて表示 
setopt list_packed

# 候補が無い場合にビープ音鳴らさない
setopt nolistbeep 

# /を勝手に削除しない
setopt noautoremoveslash

# exit時にSIGHUPを送らない
setopt nohup

# ターミナルの枠表示
case "${TERM}" in
screen)
    preexec(){
        echo -ne "\ek$1\e\\"
    }
    precmd(){
        echo -ne "\ek$(basename $SHELL)\e\\"
    }
    ;;
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}:${PWD}\007"
    }
    ;;
esac

# ,でcd ../
function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey "\," cdup

# --prefix=の補完
setopt magic_equal_subst

# ペースト時のURL自動エスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# クリップボードへコピーするグローバルエイリアス
if which pbcopy >/dev/null 2>&1 ; then 
    # Mac  
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then 
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then 
    # Cygwin 
    alias -g C='| putclip'
fi

# ヘルプの表示
#bindkey "^B" run-help

# run-help が呼ばれた時、zsh の内部コマンドの場合は該当する zsh のマニュアル表示
[ -n "`alias run-help`" ] && unalias run-help
autoload run-help

# ls /usr/local/etc などと打っている際に、C-w で単語ごとに削除
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# 改行無し出力をプロンプトで上書きしない
unsetopt promptcr

# 前方予測
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey '^xp' predict-on
bindkey '^x^p' predict-off
zstyle ':predict' verbose true
zstyle ':predict' toggle true

# コマンドオプション補完増強
# https://github.com/zsh-users/zsh-completions
if [ ! -d "~/.zsh-completions" ]; then
    fpath=(~/.zsh-completions $fpath)
fi

# 各環境依存の設定読み込み
[ -f $HOME/.zshrc.mine ] && source $HOME/.zshrc.mine


# screenの別windowのカレントディレクトリに移動
# cdd
# * author
# - Yuichi Tateno
# http://d.hatena.ne.jp/secondlife/20080218/1203303528
export CDD_PWD_FILE=$HOME/.zsh/cdd_pwd_list

function _reg_pwd_screennum() {
  if [ "$STY" != "" ]; then
    if [ ! -f "$CDD_PWD_FILE" ]; then
      echo "\n" >> "$CDD_PWD_FILE"
    fi
    _reg_cdd_pwd "$WINDOW" "$PWD"
  fi
}

function _reg_cdd_pwd() {
  if [ ! -f "$CDD_PWD_FILE" ]; then
    echo "\n" >> "$CDD_PWD_FILE"
    if [ $? = 1 ]; then
      echo "Error: Don't wrote $CDD_PWD_FILE."
      return 1
    fi
  fi
  sed -i".t" -e "/^$1:/d" "$CDD_PWD_FILE"
  sed -i".t" -e "1i \\
$1:$2" "$CDD_PWD_FILE"
}

function _cdadd {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: cdd add name path"
    echo "Example: cdd add w ~/myworkspace"
    return 1
  fi

  local -A real_path
  if which realpath >/dev/null 2>&1;then
    real_path=`realpath $2`
  else
    if which ruby >/dev/null 2>&1;then
      real_path=`ruby -rpathname -e "puts Pathname.new('$2').realpath"`
    else
      echo "cdd add require realpath or ruby"
    fi
  fi
  echo "add $1:$real_path"
  _reg_cdd_pwd "$1" "$real_path"
}

function _cddel() {
  if [ -z "$1" ]; then
    echo "Usage: cdd del name"
    return 1
  fi
  sed -i".t" -e "/^$1:/d" "$CDD_PWD_FILE"
}


function cdd() {
  if [ "$1" = "add" ]; then
    shift
    _cdadd $@
    return 0
  elif [ "$1" = "del" ]; then
    shift
    _cddel $@
    return 0
  fi

  local -A arg
  #arg=`echo $1|awk -F':' '{print \$1}'`
  arg=`echo $1|cut -d':' -f1`
  #grep "^$arg:" "$CDD_PWD_FILE" > /dev/null 2>&1
  if grep "^$arg:" "$CDD_PWD_FILE" > /dev/null 2>&1 ;then
    local -A res
    res=`grep "^$arg:" "$CDD_PWD_FILE"|sed -e "s/^$arg://;"|tr -d "\n"`
    echo "$res"
    cd "$res"
  else
    sed -e '/^$/d' "$CDD_PWD_FILE"
  fi
}


compctl -K _cdd cdd
functions _cdd() {
  reply=(`grep -v "^$WINDOW:" "$CDD_PWD_FILE"`)
}

 function chpwd() {
    _reg_pwd_screennum
 }
