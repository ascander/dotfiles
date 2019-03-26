#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='emacs'
export VISUAL='emacs'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$USER"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi

#
# Nix
#

# Initialize Nix if needed
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh;
fi

setopt shwordsplit

fpath=(
  # zsh completion and themes
  "$ZDOTDIR/site-functions"
  $fpath
)

# prompt theme; unless inside Emacs
if [ -z "$INSIDE_EMACS" ]; then
  autoload -U promptinit; promptinit
  prompt pure
else
  PROMPT="%c❯ " 
fi

# load completion
autoload -Uz compinit && compinit

#
# Customize to your needs...
#

# Source local zshrc.
if [[ -s "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# 256 color terminal
export TERM=xterm-256color

export GPG_TTY=$(tty)

path=(
  $path
  /bin
)

export LANG=en_us.utf-8
export LC_ALL=en_us.utf-8
export LC_TYPE=en_us.utf-8

HISTFILE=$HOME/.zhistory

source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Link 'git' to 'hub' if it exists
if (( $+commands[hub] )); then
    eval "$(hub alias -s)"
fi

# Scala settings
export SBT_OPTS="-Dscala.color -Dmetals.http=true"

# Scalameta Metals setup
if (( $+commands[metals] )); then
  export METALS_ENABLED="true"
fi

# Java settings
export JAVA_OPTS='-Dfile.encoding=utf8'

# Settings for 'ls'
#
# TODO use gls
export CLICOLOR=1
export LSCOLORS="exfxcxdxbxegedabagacad"

alias ls='ls -Gh'
alias lk='ls -lSr'
alias lt='ls -ltf'
alias lc='ls -lctr'
alias lu='ls -ltur'
alias ll='ls -l'
alias lr='ll -R'
alias la='ll -A'
alias l='ll'

# Miscellaneous aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -p'
alias c='clear'
alias du='du -h'
alias h='history 24'
alias ds='dirs -v | head -10'
alias ..='cd ../.'
alias ...='cd ../../.'
alias ....='cd ../../../.'
alias .....='cd ../../../../.'

