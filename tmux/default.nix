# Tmux with ./tmux.conf baked in
#
# Copied from https://github.com/nmattia/homies/blob/master/tmux/default.nix
{ fetchgit, gawk, tmux, symlinkJoin, makeWrapper, reattach-to-user-namespace ? null, tmuxPlugins, writeText }:

let

  tmux-fingers = tmuxPlugins.mkDerivation {
    pluginName = "fingers";
    src = fetchgit {
      url = "https://github.com/Morantron/tmux-fingers";
      rev = "8432c1a83e9c2fe7da1a8c683ba681f2004c0369";
      sha256 = "1bwlds81bnprwr0abwqb3d4a69y7lvby7bx2k38f7ib444l6b7ln";
    };
    dependencies = [ gawk ];
  };

  darwinConf =
    if isNull reattach-to-user-namespace then ""
    else ''
      set-option -g default-command "${reattach-to-user-namespace}/bin/reattach-to-user-namespace -l $SHELL"
      unbind-key -T copy-mode-vi Enter; bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      set -g @fingers-copy-command 'pbcopy'
    '';

  extraConf = darwinConf + ''
    run-shell ${tmux-fingers}/share/tmux-plugins/fingers/tmux-fingers.tmux
  '';

  baseConf = builtins.readFile ./tmux.conf;

  tmuxConfFile = writeText "tmux.conf" (baseConf + "\n" + extraConf);
in
  symlinkJoin {
    name = "tmux";
    buildInputs = [ makeWrapper ];
    paths = [ tmux ];
    postBuild = ''
      mkdir -p $out/conf
      cp ${tmuxConfFile} $out/conf/tmux.conf
      wrapProgram "$out/bin/tmux" \
      --add-flags "-f $out/conf/tmux.conf"
    '';
  }
