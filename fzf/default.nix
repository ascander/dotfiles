# fzf with custom configuration
#
{ fzf, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "fzf";
  buildInputs = [makeWrapper];
  paths = [ fzf ];
  postBuild = ''
    wrapProgram "$out/bin/fzf" \
    --set FZF_DEFAULT_COMMAND 'ag -g ""'
  '';
}
