# Zsh with conf files baked in
#
# TODO ceedubs should be doing more linking instead of copying?
# TODO ceedubs clean up redundant code
{ zsh, zsh-prezto, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "zsh";
  buildInputs = [makeWrapper];
  paths = [ zsh ];
  postBuild = ''
    mkdir -p $out/.zprezto
    cp ${zsh-prezto}/* $out/.zprezto -R
    cp ${./conf}/.zshrc $out/.zshrc
    cp ${./conf}/.zpreztorc $out/.zpreztorc
    wrapProgram "$out/bin/zsh" \
    --set ZDOTDIR "$out"
  '';
}
