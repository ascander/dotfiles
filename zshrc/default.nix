# Because the path of the zshrc changes upon rebuild, we cannot source it
# directly from the (vernilla) ~/.zshrc. Instead this script is created, which
# will source the latest zshrc.
#
# The zshrc script should be evaluated from the actual ~/.zshrc as follows:
#
#   if [ -x "$(command -v zshrc)" ]; then $(zshrc); fi
{ lib, writeText, writeScriptBin, geometry-zsh, cacert }:
let
  zshrc = writeText "zshrc"
    (lib.concatStringsSep "\n"
    [ (builtins.readFile ./zshrc)
      ''
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      source ${geometry-zsh}/geometry.zsh
      ''
    ]
    );
in writeScriptBin "zshrc"
  ''
    echo ". ${zshrc}"
  ''
