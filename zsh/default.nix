# Zsh with conf files baked in
#
{ zsh, symlinkJoin, makeWrapper, pure-prompt}:
symlinkJoin {
  name = "zsh";
  buildInputs = [ makeWrapper ];
  paths = [ zsh ];
  postBuild = ''
    cp ${./conf}/.zshrc $out/.zshrc
    mkdir -p "$out/site-functions"
    cp ${pure-prompt}/share/zsh/site-functions/* $out/site-functions/ -R
    wrapProgram "$out/bin/zsh" \
    --set ZDOTDIR "$out"
  '';
}
