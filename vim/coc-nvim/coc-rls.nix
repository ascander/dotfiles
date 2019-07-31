# Adapted from https://github.com/Jomik/dotfiles/blob/7b11332a0bcb7728dcbaa0da28c58a2808b94dd1/.config/nixpkgs/configurations/neovim/plugins.nix
# which is published under the MIT license with:
# Copyright (c) 2018 Jonas Holst Damtoft

{ buildVimPluginFrom2Nix, fetchFromGitHub, nodejs, yarn, yarn2nix }:
let
  pname = "coc-rls";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = pname;
    rev = "0c005a817016412e6fba56ab81d20a949c42fbd1";
    sha256 = "0h5a1a9s9rarafmfy2i77rrsmg9393hdk53v3hfzs0f00q9qk7wn";
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
}
