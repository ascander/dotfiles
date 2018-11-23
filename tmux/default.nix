# Tmux with ./tmux.conf baked in
#
# Copied from https://github.com/nmattia/homies/blob/master/tmux/default.nix
{ tmux, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "tmux";
  buildInputs = [makeWrapper];
  paths = [ tmux ];
  postBuild = ''
    wrapProgram "$out/bin/tmux" \
    --add-flags "-f ${./tmux.conf}"
  '';
}
