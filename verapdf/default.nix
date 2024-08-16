{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}: let
  verapdfVersion = "1.26.2";
  snapshotVersion = "1.26.0";
in
  maven.buildMavenPackage rec {
    pname = "verapdf";
    version = verapdfVersion;

    src = fetchFromGitHub {
      owner = "veraPDF";
      repo = "veraPDF-apps";
      rev = "v${version}";
      hash = "sha256-bWj4dX1qRQ2zzfF9GfskvMnrNU9pKC738Zllx6JsFww=";
    };

    patches = [./pin-default-maven-plugin-versions.patch];

    mvnHash = "sha256-xjy9NZM8w8uK/qF4QrguTOlUkLQCbvhON1wOh2qcp9k=";
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
