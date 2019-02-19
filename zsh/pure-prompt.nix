{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "zsh-pure-prompt-2019-02-18";
  src = fetchgit {
    url = "https://github.com/sindresorhus/pure";
    rev = "47f9bfd3463e10852c377ae5476367c28dafd351";
    sha256 = "1jpahk5rc1cs04m8r2y5djsighnw67dxqm6i6ygbip4wn39abkna";
  };

  installPhase = ''
    mkdir -p "$out/share/zsh/site-functions/"
    cp "pure.zsh" "$out/share/zsh/site-functions/prompt_pure_setup"
    cp "async.zsh" "$out/share/zsh/site-functions/async"
  '';
}
