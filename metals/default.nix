{ metalsJavaFlags ? import ./default-metals-flags.nix, stdenv, lib, fetchurl, coursier, jdk, jre, makeWrapper }:

let
  baseName = "metals";
  version = "0.7.6";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch org.scalameta:metals_2.12:${version} \
        -r sonatype:releases \
        -r "bintray:scalacenter/releases" > deps
      mkdir -p $out/share/java
      cp -n $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "03vx8n77mndpqbvq14cy3k9r4jwgjacrv56v5n87da8rqiclx37j";
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  buildInputs = [ jdk makeWrapper deps ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${jre}/bin/java $out/bin/metals \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "-cp $CLASSPATH" \
      --add-flags "${lib.concatStringsSep " " metalsJavaFlags}" \
      --add-flags "scala.meta.metals.Main"
  '';

  meta = with stdenv.lib; {
    homepage = https://scalameta.org/metals/;
    license = licenses.asl20;
    description = "Work-in-progress language server for Scala";
  };
}
