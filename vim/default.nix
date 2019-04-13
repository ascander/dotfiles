# Vim, with a set of extra packages (extraPackages) and a custom vimrc
{ neovim, vimPlugins, buildVimPluginFrom2Nix, fetchFromGitHub, makeWrapper, metals, nodejs, symlinkJoin, writeText, yarn, yarn2nix }:

let
  customRumtimeSetting = "let &runtimepath.=','.'${./rumtime}'";

  coc-nvim = import ./coc-nvim {
    inherit buildVimPluginFrom2Nix fetchFromGitHub nodejs yarn yarn2nix;
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

  coc-settings = import ./coc-nvim/coc-settings.nix { inherit metals; };

  coc-settings-file = writeText "coc-settings.json" (builtins.toJSON coc-settings );

  neovim-unwrapped = neovim.override {
    vimAlias = false;
    configure = {
      customRC = customRumtimeSetting + "\n" + builtins.readFile ./vimrc;
      packages.myVimPackage = with vimPlugins; {
        start = [
          ack-vim
          coc-nvim
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
  };
in
  symlinkJoin {
    name = "nvim";
    buildInputs = [ makeWrapper ];
    paths = [ neovim-unwrapped ];
    postBuild = ''
      mkdir -p $out/conf
      cp ${coc-settings-file} $out/conf/coc-settings.json
      wrapProgram "$out/bin/nvim" \
        --set VIMCONFIG "$out/conf"
      makeWrapper "$out/bin/nvim" "$out/bin/vim"
    '';
  }
