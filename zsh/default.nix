/*
  Zsh with conf files baked in

  site-functions is a list of site-functions directories, for example:
  [ "${ddgr}/share/zsh/site-functions" "${hub}/share/zsh/site-functions" ]
*/
{ zsh, symlinkJoin, makeWrapper, zsh-syntax-highlighting, lib, site-functions }:
symlinkJoin {
  name = "zsh";
  buildInputs = [ makeWrapper ];
  paths = [ zsh ];
  postBuild = ''
    cp ${./conf}/.zshrc $out/.zshrc
    mkdir -p "$out/site-functions"
    ${lib.concatMapStrings (s: "cp ${s}/* $out/site-functions/ -R;") site-functions}
    cp ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting $out/ -R
    wrapProgram "$out/bin/zsh" \
    --set ZDOTDIR "$out"
  '';
}
