# ¸À¸ìÀßÄê
export LANG=ja_JP.UTF-8 

# mailcheck off
export MAILCHECK=0

# umask
umask 022

# BSDÍÑls¤Î¥«¥é¡¼ÀßÄê
export LSCOLORS=exfxbxdxcxegedabagacad

# OS¤Ë¤è¤Ã¤Æls¥ª¥×¥·¥ç¥ó¤òÊ¬¤±¤ë
case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

# alias
setopt complete_aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -l'
alias vi='vim'
alias h='history -E -32'

# historyÀßÄê
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

# local::libÍÑPATHÀßÄê(¥µ¡¼¥Ð¡¼°ÍÂ¸)
eval $(perl -I$HOME/local/lib/perl5 -Mlocal::lib=$HOME/local)
export PATH=$PATH:~/local/svn/bin:~/local/bin/perl5

# zshÊä´°µ¡Ç½
autoload -U compinit
compinit

# ls¤ÎÇÛ¿§¤ÈÊä´°¸õÊä¤ÎÇÛ¿§¤ò¹ç¤ï¤»¤ë
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=32' 'bd=46;34' 'cd=43;34'

# ¥×¥í¥ó¥×¥ÈÀßÄê
setopt prompt_subst
autoload colors
colors
PROMPT="%B%{[35;40m%}[orz %c/]%%%{[m%}%b%{$reset_color%} "
PROMPT2="%{[35;40m%}%_%%%{[m%}%{$reset_color%} "
SPROMPT="%{[35;40m%}%r is correct? [n,y,a,e]:%{[m%}%{$reset_color%} "
RPROMPT="%{[36;40m%}[%~]%{m%}%{${reset_color}%} "

# TAB¤ÇÊÑ´¹¸õÊäÀÚ¤êÂØ¤¨
setopt auto_menu

# cd¥³¥Þ¥ó¥ÉÌµ¤·¤Ç¥Ç¥£¥ì¥¯¥È¥ê°ÜÆ°
setopt auto_cd

# cd - ¤Ç¥Ç¥£¥ì¥¯¥È¥ê°ÜÆ°²ÄÇ½
setopt auto_pushd

# cd - ¸õÊä¤«¤Ö¤Ã¤Æ¤ë¤Î¤ÏÌµ»ë¤¹¤ë
setopt pushd_ignore_dups

# ¥³¥Þ¥ó¥É¥Á¥§¥Ã¥¯
setopt correct

# ¸õÊä¤òµÍ¤á¤ÆÉ½¼¨ 
setopt list_packed

# ¸õÊä¤¬Ìµ¤¤¾ì¹ç¤Ë¥Ó¡¼¥×²»ÌÄ¤é¤µ¤Ê¤¤
setopt nolistbeep 

# /¤ò¾¡¼ê¤Ëºï½ü¤·¤Ê¤¤
setopt noautoremoveslash

# ¥¿¡¼¥ß¥Ê¥ë¤ÎÏÈÉ½¼¨
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

