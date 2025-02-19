{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}: let
in
  maven.buildMavenPackage rec {
    pname = "litterbox";
    version = "1.9.2";

    src = fetchFromGitHub {
      owner = "se2p";
      repo = "LitterBox";
      rev = "v${version}";
      hash = "sha256-nXI5Z3l1YwlDFtzkF45/jIM+82dghFblZZU/lo4RwD4=";
    };

    patches = [./pin-default-maven-plugin-versions.patch];

    mvnHash = "sha256-cTaRhSDe5gOp3hiK77kVUAE3UfINbijBntWJvoS3G/M=";
    mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/share/java
      install -Dm644 target/LitterBox-${version}.full.jar $out/share/java/litterbox-${version}.jar

      makeWrapper ${jre}/bin/java $out/bin/litterbox \
        --add-flags "-jar $out/share/java/litterbox-${version}.jar"
    '';

    meta = with lib; {
      description = "A static code analysis tool for detecting bugs in Scratch projects";
      homepage = "https://scratch.fim.uni-passau.de/litterbox/";
      licence = [licenses.gpl3Plus];
    };
  }
