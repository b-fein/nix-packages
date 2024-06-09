{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}: let
  verapdfVersion = "1.27.18";
  snapshotVersion = "1.27.0-SNAPSHOT";
in
  maven.buildMavenPackage rec {
    pname = "verapdf";
    version = verapdfVersion;

    src = fetchFromGitHub {
      owner = "veraPDF";
      repo = "veraPDF-apps";
      rev = "v${version}";
      hash = "sha256-LO8cMEiNoOrj6+SDZ4rrEPRXT33h7OQ/HJ8fLrbumAs=";
    };

    mvnHash = "sha256-pY2s5PWPax1K36tf0jJUoOosF2+JX17HyvQ0b6/6D28=";
    mvnParameters = "-pl '!installer'";

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/share/java
      install -Dm644 greenfield-apps/target/greenfield-apps-${snapshotVersion}.jar $out/share/java/verapdf-greenfield-apps-${version}.jar
      install -Dm644 pdfbox-apps/target/pdfbox-apps-${snapshotVersion}.jar $out/share/java/verapdf-pdfbox-apps-${version}.jar

      makeWrapper ${jre}/bin/java $out/bin/verapdf-greenfield \
        --add-flags "-jar $out/share/java/verapdf-greenfield-apps-${version}.jar"
      makeWrapper ${jre}/bin/java $out/bin/verapdf-pdfbox \
        --add-flags "-jar $out/share/java/verapdf-pdfbox-apps-${version}.jar"
    '';

    meta = with lib; {
      description = "Industry Supported PDF/A and PDF/UA Validation";
      homepage = "https://verapdf.org/software";
      licence = [licenses.gpl3Plus licences.mpl2Plus];
    };
  }
