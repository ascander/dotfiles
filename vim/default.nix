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

  custom-vim-test = buildVimPluginFrom2Nix {
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
          vim-airline
          vim-airline-themes
          vim-easy-align
          vim-fugitive
          vim-lsc
          vim-markdown
          vim-nix
          vim-rhubarb
          vim-scala
          vim-surround
          vimux
          custom-vim-test
        ];
      };
    };
  }
