with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "yacy_search_server";
  version = "1.940";
  #src = pkgs.fetchFromGitHub {
  #  owner = "yacy";
  #  repo = "${name}";
  #  rev = "3ede322f5e25ea90f3865b4542ceb276d969491f";
  #  sha256 = "sha256-P8WT2p0ZxfXfddvn5LMDbZhY2DRztG2WddiZU0M8vN4=";
  #};
  src = fetchurl {
    url = "https://download.yacy.net/yacy_v1.940_202405270005_70454654f.tar.gz";
    #hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    hash = "sha256-tgenRi68Es/TDC/7a4STOcjTGpKNOjXdz4hl9Yqj2IA=";
  };
  nativeBuildInputs = [ git jdk23 ];
  buildInputs = [ jdk23 ];

  installPhase = ''
    mkdir -p $out
    echo -e -n "#!/bin/bash\n$out/startYACY.sh" > ./bin/yacystart
    echo " \"\$@\"" >> ./bin/yacystart
    echo -e -n "#!/bin/bash\n$out/stopYACY.sh" > ./bin/yacystop
    echo " \"\$@\"" >> ./bin/yacystop
    echo -e -n "#!/bin/bash\n$out/restartYACY.sh" > ./bin/yacyrestart
    echo " \"\$@\"" >> ./bin/yacyrestart
    chmod +x ./bin/yacystart
    chmod +x ./bin/yacystop
    chmod +x ./bin/yacyrestart
    cp -r ./* $out
  '';

  shellHook = ''
    export PATH="$PATH:$out"
  '';
}
