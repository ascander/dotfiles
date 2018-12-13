# Vim, with a set of extra packages (extraPackages) and a custom vimrc
{ neovim, vimPlugins, buildVimPluginFrom2Nix, fetchFromGitHub }:

let
  customRumtimeSetting = "let &runtimepath.=','.'${./rumtime}'";

  vim-lsc = buildVimPluginFrom2Nix {
    name = "vim-lsc-2018-11-30";
    src = fetchFromGitHub {
      owner = "natebosch";
      repo = "vim-lsc";
      rev = "4f7b89c8a0920cc926f35bf64f831b50e8fb572d";
      sha256 = "0icw2iych2wrzmnp8zi2p6b0j1wzwy3p0b4lljs7xbm1avddc1p9";
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
          vim-lsc
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
