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

# # Set up Emacs if we've installed a current version in the usual place
# if [ -d "/Applications/Emacs.app" ]; then
#     alias installed_emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
#     alias installed_emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
# 
#     _emacsfun() {
#         # Get a list of Emacs frames
#         frameslist=`installed_emacsclient --alternate-editor '' --eval '(frame-list)' 2>/dev/null | egrep -o '(frame)+'`
# 
#         if [ "$(echo "$frameslist" | sed -n '$=')" -ge 2 ]; then
#             # Prevent creating another frame if there is at least one present
#             installed_emacsclient --alternate-editor "" "$@"
#         else
#             # Create a new frame otherwise
#             installed_emacsclient --alternate-editor "" --create-frame "$@"
#         fi
#     }
# 
#     _emacslauncher() {
#         if [ "$#" -ge "2" -a "$2" = "-" ]; then
#             tempfile="$(mktemp emacs-stdin-$USER.XXXXXXX --tmpdir)"
#             cat - > "$tempfile"
#             _emacsfun --no-wait "$tempfile"
#         else
#             _emacsfun "$@"
#         fi
#     }
# 
#     export EMACS_LAUNCHER=_emacslauncher
#     export EDITOR="${EDITOR:-${EMACS_LAUNCHER}}"
#     
#     alias emacs="$EMACS_LAUNCHER --no-wait" # route Emacs to use the launcher
#     alias e=emacs                           # for convenience
#     alias te="$EMACS_LAUNCHER -nw"          # in a terminal (if you have to)
#     alias eeval="$EMACS_LAUNCHER --eval"    # like running `M-x eval` from outside Emacs
# fi

# Initialize fasd
eval "$(fasd --init auto)"

# fasd aliases
alias e='f -e emacs'
alias v='f -e vim'

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

alias gs='git status -sb'

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

alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

# ANSI hack for tree
if (( $+commands[tree] )); then
  alias tree='tree -A'
fi

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

