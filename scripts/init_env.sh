# install the font that I like
if [ ! -f $HOME/Library/Fonts/Droid+Sans+Mono+for+Powerline.otf ]; then
  curl --create-dirs -o $HOME/Library/Fonts/Droid+Sans+Mono+for+Powerline.otf 'https://github.com/powerline/fonts/raw/c320e67b6564b9bf3c76aade296d47b57ca6d529/DroidSansMono/Droid%20Sans%20Mono%20for%20Powerline.otf'
fi

# only show terminal scrollbar when scrolling
defaults write com.apple.Terminal AppleShowScrollBars -string WhenScrolling
