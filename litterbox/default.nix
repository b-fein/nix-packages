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
    version = "1.11";

    src = fetchFromGitHub {
      owner = "se2p";
      repo = "LitterBox";
      rev = "v${version}";
      hash = "sha256-cki+0l94/0WgZ2svXOHwIgsxzME39BSMKB00typWtpE=";
    };

    patches = [./pin-default-maven-plugin-versions.patch];

    mvnHash = "sha256-/rPqi+GISAhRXcFtAkMS8krxC8QIA2Q6SEEwPPoGAfk=";
    mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/share/java
      install -Dm644 target/LitterBox-${version}.full.jar $out/share/java/litterbox-${version}.jar

      makeWrapper ${jre}/bin/java $out/bin/litterbox \
        --add-flags "-jar $out/share/java/litterbox-${version}.jar"
    '';

    meta = {
      description = "A static code analysis tool for detecting bugs in Scratch projects";
      homepage = "https://scratch.fim.uni-passau.de/litterbox/";
      licence = [lib.licenses.gpl3Plus];
    };
  }
