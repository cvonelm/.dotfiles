# private stuff
source $HOME/.zprofile

setopt append_history
setopt share_history
setopt extended_history
setopt histignorespace

setopt auto_cd

setopt extended_glob

setopt longlistjobs

setopt notify

setopt hash_list_all

setopt completeinword

setopt nohup
setopt nobeep

#move the cursor to the end of the word if a completion is performed inside a word
setopt always_to_end

# don't push the same dir twice.
setopt pushd_ignore_dups

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# don't error out when unset parameters are used
setopt unset

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

HISTFILE=${HOME}/.zsh_history
HISTSIZE=5000
SAVEHIST=10000 # useful for setopt append_history

# Load a few modules
for mod in parameter complist deltochar mathfunc ; do
    zmodload  zsh/${mod} 2>/dev/null
done && builtin unset -v mod

# completion system
autoload compinit
typeset -a tmp
zstyle -a ':grml:completion:compinit' arguments tmp
compinit -d ${HOME}/.zcompdump "${tmp[@]}"
unset tmp

bindkey -v

# Custom widgets:
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

alias dotfiles='/usr/bin/git --git-dir="$HOME/dev/.dotfiles/" --work-tree="$HOME"'

# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

alias ls="command ls -v --color=auto"
#a1# List all files, with colors (\kbd{ls -la \ldots})
alias la="command ls -la -v --color=auto"
#a1# List files with long colored list, without dotfiles (\kbd{ls -l \ldots})
alias ll="command ls -l -v --color=auto"
#a1# List files with long colored list, human readable sizes (\kbd{ls -hAl \ldots})
alias lh="command ls -hAl -v --color=auto"
#a1# List files with long colored list, append qualifier to filenames (\kbd{ls -l \ldots})\\&\quad(\kbd{/} for directories, \kbd{@} for symlinks ...)
alias l="command ls -l -v --color=auto"

alias ip='command ip -color=auto'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'


alias vim='nvim'
alias sudo='sudo-rs'
# color setup for ls:
which dircolors &> /dev/null && eval $(dircolors -b)

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

PROMPT='%~ %# '

# Called when executing a command
function preexec {
    print -Pn "\e]0;${(q)1}\e\\"
}

