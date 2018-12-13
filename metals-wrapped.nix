{  metals, symlinkJoin, makeWrapper }:

symlinkJoin {
  name = "metals-vim";
  buildInputs = [ makeWrapper ];
  paths = [ metals ];
  postBuild = ''
    wrapProgram "$out/bin/metals-vim" \
      --add-flags "-XX:+UseG1GC" \
      --add-flags "-XX:+UseStringDeduplication" \
      --add-flags "-Xss4m" \
      --add-flags "-Xms1G" \
      --add-flags "-Xmx4G" \
      --add-flags "-Dmetals.client=vim-lsc"
  '';
}
