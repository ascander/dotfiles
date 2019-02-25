# Vim, with a set of extra packages (extraPackages) and a custom vimrc
{ neovim, vimPlugins, buildVimPluginFrom2Nix, fetchFromGitHub }:

let
  customRumtimeSetting = "let &runtimepath.=','.'${./rumtime}'";

  vim-lsc = buildVimPluginFrom2Nix {
    name = "vim-lsc-2019-02-25";
    src = fetchFromGitHub {
      owner = "natebosch";
      repo = "vim-lsc";
      rev = "f7adfe36af3afbd557c885819b6218a256f375ea";
      sha256 = "0p91sjb2wbcs3x5xj4rppadx3nvkq6b7i2k3ih74wgmsfzqri94w";
    };
  };

  vim-test-custom = buildVimPluginFrom2Nix {
    name = "vim-test-2019-01-31";
    src = fetchFromGitHub {
      owner = "janko-m";
      repo = "vim-test";
      rev = "7e5e118720be538fd560dee8bf34c3f139f2b037";
      sha256 = "11k0dvbs4kc448ff2a61q7rgprhiv28rxbbs1g20ljhafzfz52q3";
    };
  };

  vimux = buildVimPluginFrom2Nix {
    name = "vimux-2019-01-31";
    src = fetchFromGitHub {
      owner = "benmills";
      repo = "vimux";
      rev = "37f41195e6369ac602a08ec61364906600b771f1";
      sha256 = "0k7ymak2ag67lb4sf80y4k35zj38rj0jf61bf50i6h1bgw987pra";
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
          dhall-vim
          fzf-vim
          fzfWrapper
          rainbow
          vim-abolish
          vim-airline
          vim-airline-themes
          vim-easy-align
          vim-easymotion
          vim-fugitive
          vim-lsc
          vim-markdown
          vim-nix
          vim-rhubarb
          vim-scala
          vim-surround
          vim-test-custom
          vimux
        ];
      };
    };
  }
