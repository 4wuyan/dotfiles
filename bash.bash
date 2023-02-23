#!/usr/bin/env bash

# ln -s <this_file> ~/.bashrc
# or in ~/.bashrc
# source <this_file>

[ -z "$PS1" ] && return  # If not running interactively, don't do anything

# ------------
# General
# ------------

shopt -s checkwinsize  # check the window size after each command and,
  # if necessary, update the values of LINES and COLUMNS.
stty -ixon  # Free Ctrl-S for forward-i-search
shopt -s globstar  # enable **


# ------------
# History
# ------------
HISTCONTROL=ignoreboth  # don't put duplicate lines or lines starting with space
shopt -s histappend  # append to the history file, don't overwrite it
HISTSIZE=10000
HISTFILESIZE=100000


# ------------
# Aliases
# ------------

alias cp="cp --interactive"  # confirm if overwriting
alias gs='git status'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias mv="mv --interactive"  # confirm if overwriting
alias v='vim'
alias vi='vim'


# ------------
# Completion
# ------------

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# ------------
# PS1
# ------------

color_prompt=no
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  # The terminal driver starts processing after `\e]0;`,
  # and uses everything up to `\a` as the terminal window title.
  PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
esac


# ------------
# Colors
# ------------

if [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


# ------------
# Ubuntu specific
# ------------

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
  # make less more friendly for non-text input files, see lesspipe(1)


# ------------
# WSL specific
# ------------

if [[ "$(< /proc/sys/kernel/osrelease)" == *Microsoft ]]; then
  export DOCKER_HOST=tcp://localhost:2375
  if [[ "$(umask)" == "0000" ]]; then umask 0022; fi
fi


# ------------
# Homebrew
# ------------

if [ -d /home/linuxbrew/.linuxbrew ]; then
  # eval $(SHELL=bash /home/linuxbrew/.linuxbrew/bin/brew shellenv) is too slow!
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
  export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH}";
fi


# ------------
# Handy functions
# ------------

colors() {
  local fgc bgc vals seq0

  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}
        # remove trailing `;`
        # Now vals should be something like `31;41`, `32`

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      printf " ${seq0}TEXT\e[m"
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
        # First test if `vals` is EMPTY. Returns "" if empty.
        # If not empty, then test if `vals` is SET.
        # If set, then append a `;`.
        # Two tests are needed because ${vals+$vals;} returns ";" when vals=""
    done
    echo; echo
  done
}

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
