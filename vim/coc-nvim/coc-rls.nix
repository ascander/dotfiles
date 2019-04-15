# Adapted from https://github.com/Jomik/dotfiles/blob/7b11332a0bcb7728dcbaa0da28c58a2808b94dd1/.config/nixpkgs/configurations/neovim/plugins.nix
# which is published under the MIT license with:
# Copyright (c) 2018 Jonas Holst Damtoft

{ buildVimPluginFrom2Nix, fetchFromGitHub, nodejs, yarn, yarn2nix }:
let
  pname = "coc-rls";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "ceedubs";
    repo = pname;
    rev = "35db2b5c7e901918ef2b87fc10851f4d27db1366";
    sha256 = "1nmyvmlknhh67h1vjm5i9p285khdh77hzlam34r0qqm172qpyw8b";
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
