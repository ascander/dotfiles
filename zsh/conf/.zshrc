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

export EDITOR='vim'
export VISUAL='vim'
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

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh;
fi

setopt shwordsplit

fpath=(
  # zsh completion and themes
  "$ZDOTDIR/site-functions"
  $fpath
)

# prompt theme
autoload -U promptinit; promptinit
prompt pure

# load completion
autoload -Uz compinit && compinit

# Customize to your needs...
#
# Source local zshrc.
if [[ -s "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# kj to go into normal mode on the command line
bindkey -M viins 'kj' vi-cmd-mode

# <C-r> for history search
bindkey '^R' history-incremental-search-backward

# prompt when overwriting files
alias cp='cp -i'

# pretty ls colors
alias ls='ls -G'

# run emacs in terminal mode
alias emacs='emacs -nw'

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
export JAVA_OPTS='-Dfile.encoding=utf8'

HISTFILE=$HOME/.zhistory

source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# set up direnv
eval "$(direnv hook zsh)"
