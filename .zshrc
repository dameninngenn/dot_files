# ��������
export LANG=ja_JP.UTF-8 

# mailcheck off
export MAILCHECK=0

# umask
umask 022

# BSD��ls�Υ��顼����
export LSCOLORS=exfxbxdxcxegedabagacad

# OS�ˤ�ä�ls���ץ�����ʬ����
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

# history����
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

# local::lib��PATH����(�����С���¸)
eval $(perl -I$HOME/local/lib/perl5 -Mlocal::lib=$HOME/local)
export PATH=$PATH:~/local/svn/bin:~/local/bin/perl5

# zsh�䴰��ǽ
autoload -U compinit
compinit

# ls���ۿ����䴰������ۿ����碌��
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=32' 'bd=46;34' 'cd=43;34'

# �ץ��ץ�����
setopt prompt_subst
autoload colors
colors
PROMPT="%B%{[35;40m%}[orz %c/]%%%{[m%}%b%{$reset_color%} "
PROMPT2="%{[35;40m%}%_%%%{[m%}%{$reset_color%} "
SPROMPT="%{[35;40m%}%r is correct? [n,y,a,e]:%{[m%}%{$reset_color%} "
RPROMPT="%{[36;40m%}[%~]%{m%}%{${reset_color}%} "

# TAB���Ѵ������ڤ��ؤ�
setopt auto_menu

# cd���ޥ��̵���ǥǥ��쥯�ȥ��ư
setopt auto_cd

# cd - �ǥǥ��쥯�ȥ��ư��ǽ
setopt auto_pushd

# cd - ���䤫�֤äƤ�Τ�̵�뤹��
setopt pushd_ignore_dups

# ���ޥ�ɥ����å�
setopt correct

# �����ͤ��ɽ�� 
setopt list_packed

# ���䤬̵�����˥ӡ��ײ��Ĥ餵�ʤ�
setopt nolistbeep 

# /�򾡼�˺�����ʤ�
setopt noautoremoveslash

# �����ߥʥ����ɽ��
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

