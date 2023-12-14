export EDITOR="nvim"
export VISUAL="nvim"
export GPG_TTY="$(tty)"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PAGER="less"

# Pick up terminfo for `tmux-256color` and `alacritty`
export TERMINFO_DIRS="$HOME/.local/share/terminfo:$HOME/.terminfo"
