setopt shwordsplit

fpath=(
    # zsh completion and themes
    "$ZDOTDIR/site-functions"
    $fpath
)

# load completion
autoload -Uz compinit && compinit

#
# Customize to your needs...
#

export GPG_TTY=$(tty)

export LANG=en_us.utf-8
export LC_ALL=en_us.utf-8
export LC_TYPE=en_us.utf-8

source "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
