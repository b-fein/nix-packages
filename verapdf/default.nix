{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}: let
  verapdfVersion = "1.28.1";
  snapshotVersion = "1.28.0";
in
  maven.buildMavenPackage rec {
    pname = "verapdf";
    version = verapdfVersion;

    src = fetchFromGitHub {
      owner = "veraPDF";
      repo = "veraPDF-apps";
      rev = "v${version}";
      hash = "sha256-UdQePAoEw/+Y1fFWQfheELzl56WXe0JNlguPHow+DFU=";
    };

    patches = [./pin-default-maven-plugin-versions.patch];

    mvnHash = "sha256-Zl5cdZP89PuSk9e0DhOQd1uGW8ov+c1zI25ciTtbMUc=";
    mvnParameters = "-pl '!installer' -Dverapdf.timestamp=1980-01-01T00:00:02Z -Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

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

    meta = {
      description = "Industry Supported PDF/A and PDF/UA Validation";
      homepage = "https://verapdf.org/software";
      licence = [lib.licenses.gpl3Plus lib.licences.mpl2Plus];
    };
  }
