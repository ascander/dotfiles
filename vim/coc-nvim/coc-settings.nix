{ metals }:

{
  coc.preferences.extensionUpdateCheck = "never";

  diagnostic.errorSign = "🚽";

  languageserver = {
    metals = {
      command = metals + "/bin/metals";
      filetypes = [ "scala" "sbt" ];
    };
    rls = {
      command = "rls";
      filetypes = [ "rs" ];
    };
  };

  suggest = {
    autoTrigger = "trigger";
    noselect = false;
    enablePreview = true;
  };

  rust-client.disableRustup = true;
}
