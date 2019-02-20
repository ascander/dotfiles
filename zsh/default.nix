# Zsh with conf files baked in
{ zsh, symlinkJoin, makeWrapper, pure-prompt, ddgr, zsh-syntax-highlighting, hub }:
symlinkJoin {
  name = "zsh";
  buildInputs = [ makeWrapper ];
  paths = [ zsh ];
  postBuild = ''
    cp ${./conf}/.zshrc $out/.zshrc
    mkdir -p "$out/site-functions"
    cp ${pure-prompt}/share/zsh/site-functions/* $out/site-functions/ -R
    cp ${ddgr}/share/zsh/site-functions/* $out/site-functions/ -R
    cp ${hub}/share/zsh/site-functions/* $out/site-functions/ -R
    cp ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting $out/ -R
    wrapProgram "$out/bin/zsh" \
    --set ZDOTDIR "$out"
  '';
}
