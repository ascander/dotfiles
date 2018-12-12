# Vim, with a set of extra packages (extraPackages) and a custom vimrc
{ neovim, vimPlugins }:

let
  customRumtimeSetting = "let &runtimepath.=','.'${./rumtime}'";
in
  neovim.override {
    vimAlias = true;
    configure = {
      customRC = customRumtimeSetting + "\n" + builtins.readFile ./vimrc;
      packages.myVimPackage = with vimPlugins; {
        start = [
          ack-vim
          ctrlp-vim
          vim-markdown
          vim-scala
          vim-fugitive
          vim-rhubarb
          vim-surround
          vim-airline
          vim-airline-themes
          vim-nix
        ];
      };
    };
  }
