{ stdenv, lib, fetchurl, coursier, jdk, jre, makeWrapper }:

let
  baseName = "metals-vim";
  version = "0.3.1";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} \
        -r "bintray:scalacenter/releases" > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "09p0y9fh6awl3vrdxwa3jd33y7q0kk97sv45lxyh5a2ri5d85wnc";
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  buildInputs = [ jdk makeWrapper deps ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/metals-vim \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "-cp $CLASSPATH scala.meta.metals.Main" \
      --add-flags "-XX:+UseG1GC" \
      --add-flags "-XX:+UseStringDeduplication" \
      --add-flags "-Xss4m" \
      --add-flags "-Xms1G" \
      --add-flags "-Xmx4G" \
      --add-flags "-Dmetals.client=vim-lsc"
  '';

  meta = with stdenv.lib; {
    homepage = https://scalameta.org/metals/;
    license = licenses.asl20;
    description = "Work-in-progress language server for Scala";
    maintainers = [
      {
        email = "ceedubs@gmail.com";
        github = "ceedubs";
        name = "Cody Allen";
      }
    ];
  };
}
