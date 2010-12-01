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

# prompt表示設定
PROMPT="%B%1(v|%{[32;40m%}%1v%{[m%}|)%b%B%{[35;40m%}[orz %c/]%%%{[m%}%b%{$reset_color%} "
PROMPT2="%{[35;40m%}%_%%%{[m%}%{$reset_color%} "
SPROMPT="%{[35;40m%}%r is correct? [n,y,a,e]:%{[m%}%{$reset_color%} "
RPROMPT="%{[36;40m%}[%~]%{m%}%2(v|%B%{[31;40m%}(%2v)%{[m%}|)%{${reset_color}%}"


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


# 各環境依存の設定読み込み
[ -f $HOME/.zshrc.mine ] && source $HOME/.zshrc.mine

