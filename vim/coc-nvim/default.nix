# Adapted from https://github.com/Jomik/dotfiles/blob/7b11332a0bcb7728dcbaa0da28c58a2808b94dd1/.config/nixpkgs/configurations/neovim/plugins.nix
# which is published under the MIT license with:
# Copyright (c) 2018 Jonas Holst Damtoft

{ buildVimPluginFrom2Nix, fetchFromGitHub, nodejs, yarn, yarn2nix }:
let
  pname = "coc.nvim";
  version = "0.0.67";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aqsgz76byqdddwk53gvyn20zk5xaw14dp2kjvl0v80801prqi93";
  };

  deps = yarn2nix.mkYarnModules rec {
    inherit version pname;
    name = "${pname}-modules-${version}";
    packageJSON = src + "/package.json";
    yarnLock = src + "/yarn.lock";
  };
in buildVimPluginFrom2Nix {
  inherit version pname src;

  name = pname + "-" + version;

  propagatedBuildInputs = [ nodejs ];

  configurePhase = ''
    mkdir -p node_modules
    ln -s ${deps}/node_modules/* node_modules/
    ln -s ${deps}/node_modules/.bin node_modules/
  '';

  buildPhase = ''
    ${yarn}/bin/yarn build
  '';

  postFixup = ''
    substituteInPlace $target/autoload/coc/util.vim \
      --replace "'yarnpkg'" "'${yarn}/bin/yarnpkg'" \
      --replace "'node'" "'${nodejs}/bin/node'"
    substituteInPlace $target/autoload/health/coc.vim \
      --replace "'yarnpkg'" "'${yarn}/bin/yarnpkg'"
  '';
}
