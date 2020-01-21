{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "geometry-zsh-${version}";
  src = fetchgit {
    url = "https://github.com/geometry-zsh/geometry";
    rev = "d78d0daab3e16d19043fd225fe30bf38de3b33ad";
    sha256 = "0sy5v3id31k4njr5pamh4hx238x0pcpgi0yh90jpbci690i8vdab";
  };

  installPhase = ''
    mkdir -p "$out"
    cp "geometry.zsh" "$out/geometry.zsh"
    cp -r "functions" "$out"
  '';
}
