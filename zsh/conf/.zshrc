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

export NIX_PROFILE="${HOME}/.nix-profile"

# Initialize Nix if needed
if [ -e "${NIX_PROFILE}/etc/profile.d/nix.sh" ]; then
  . "${NIX_PROFILE}/etc/profile.d/nix.sh";

  # Set some aliases
  alias ns='nix-shell'
  alias ne='nix-env'
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


# Set up Emacs if we're using a Nix-installed version
if [[ -x "${NIX_PROFILE}/bin/emacsclient" ]]; then
    # Launches Emacs in a smrt way
    #
    # First, check to see if there are any existing Emacs frames. If so, connect
    # to the existing one. If not, create one. By going through `emacsclient` we
    # also start the Emacs server if it isn't running.
    #
    # Note: the minimum number of frames required is 2. This is not a mistake. If
    # this is set to 1, Emacs does not successfully connect to the existing frame.
    # My best guess at explaining this is that running the Emacs daemon consumes a
    # frame, and counting actual frames opened is 2-indexed.
    _emacslauncher() {
        if [[ "$(emacsclient --alternate-editor "" --eval '(length (frame-list))' 2>/dev/null)" -ge 2 ]]; then
            emacsclient --alternate-editor "" "$@"
        else
            emacsclient --alternate-editor "" --create-frame "$@"
        fi
    }

    # Set up environment with smrt Emacs
    export EDITOR='emacsclient'
    export VISUAL='emacsclient'

    # Some aliases
    alias emacs='_emacslauncher --no-wait'
    alias e=emacs
    alias temacs='_emacslauncher --no-wait -nw'
    alias te=temacs
    alias eeval='_emacslauncher --eval'
    alias ke="_emacslauncher --eval '(kill-emacs)'"
fi

# Initialize fasd
eval "$(fasd --init auto)"

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

# Scala development aliases
alias kt='find . -name "target" -type d -print0 | xargs -0 rm -rf'

# Java settings
export JAVA_OPTS='-Dfile.encoding=utf8'

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Git aliases
alias g='git'

alias gs='git status'
alias gst='git status -sb'
alias gd='git diff'

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'

alias gc='git commit -v'
alias gca='git commit -v -a'

alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout master'

alias gl='git pull'
alias gup='git pull --rebase'
alias glum='git pull upstream master'

alias grv='git remote -v'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

# ANSI hack for tree
if (( $+commands[tree] )); then
  alias tree='tree -A'
fi

# Shortcut for rehashing nix environment
nn() {
    DEFAULT_NIX="${HOME}/code/dotfiles/default.nix"
    if [[ -f "$DEFAULT_NIX" ]]; then
        nix-env -f "$DEFAULT_NIX" -i --remove-all && exec $SHELL
    fi
}

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
