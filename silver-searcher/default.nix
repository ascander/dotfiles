# silver-searcher, with environment configuration
#
# This is pretty clunky, but it sets XDG_CONFIG_HOME to be the git configuration directiory so that
# it will find the right ignore file. There's probably a better way to do this...
{ silver-searcher, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "cody-custom-silver-searcher";
  buildInputs = [ makeWrapper ];
  paths = [ silver-searcher ];
  postBuild = ''
    wrapProgram "$out/bin/ag" \
    --set XDG_CONFIG_HOME "${../git}/config"
  '';
}
