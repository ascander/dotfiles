{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  date = "01-28-2020";
  name = "dircolors-solarized-${date}";
  src = fetchgit {
    url = "https://github.com/seebi/dircolors-solarized";
    rev = "5fb86a3f947f0e8b3005871c2f97df80e80f3016";
    sha256 = "1bcdnfdagwjfrkrwnmdy8p2dnhl9xrii7xg6pjwhgvfm4cak7fgy";
  };

  buildPhase = ''
    echo "ignoring Makefile, doing nothing"
  '';

  installPhase = ''
    mkdir -p "$out/share/zsh/dircolors-solarized"
    for file in dircolors\.*; do cp "$file" "$out/share/zsh/dircolors-solarized/."; done
  '';
}
