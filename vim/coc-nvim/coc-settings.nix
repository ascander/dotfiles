{ metals }:

{
  coc.preferences.extensionUpdateCheck = "never";

  diagnostic.errorSign = "🚽";

  languageserver = {
    scala = {
      command = metals + "/bin/metals";
      filetypes = [ "scala" "sbt" ];
    };
    rust = {
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
