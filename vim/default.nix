# Vim, with a set of extra packages (extraPackages) and a custom vimrc
{ neovim, vimPlugins, buildVimPluginFrom2Nix, fetchFromGitHub }:

let
  customRumtimeSetting = "let &runtimepath.=','.'${./rumtime}'";

  vim-lsc = buildVimPluginFrom2Nix {
    name = "vim-lsc-2018-12-12";
    src = fetchFromGitHub {
      owner = "natebosch";
      repo = "vim-lsc";
      rev = "fe6d3bd6328d60cfe8c799a10c35f11153c082c9";
      sha256 = "03rjbgj8647pvr1p2dqrp13z5793ivkb0ajwc65r604wgr5nva8j";
    };
  };
in
  neovim.override {
    vimAlias = true;
    configure = {
      customRC = customRumtimeSetting + "\n" + builtins.readFile ./vimrc;
      packages.myVimPackage = with vimPlugins; {
        start = [
          ack-vim
          ctrlp-vim
          dhall-vim
          vim-airline
          vim-airline-themes
          vim-fugitive
          vim-lsc
          vim-markdown
          vim-nix
          vim-rhubarb
          vim-scala
          vim-surround
        ];
      };
    };
  }
