# pijul, with config baked in
{ pijul, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "pijul";
  buildInputs = [ makeWrapper ];
  paths = [ pijul ];
  postBuild = ''
    wrapProgram "$out/bin/pijul" \
    --set PIJUL_CONFIG_DIR "${./config}"
  '';
}
