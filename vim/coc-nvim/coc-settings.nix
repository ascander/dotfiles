{ metals }:

{
  suggest.noselect = false;
  suggest.enablePreview = true;
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
  rust-client.disableRustup = true;
}
