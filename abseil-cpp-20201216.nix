
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "abseil-cpp";
  version = "20201216";
  src = pkgs.fetchFromGitHub {
    owner = "abseil";
    repo = "${name}";
    rev = "1bae23e32ba1f1af7c7d1488a69a351ec96dc98d";
    sha256 = "sha256-WIsQ6z7a017YxeTrZeJLBNFNI8rZXU7s3qi5bXAj0+A=";
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
    libtorrent-rasterbar
    boost
    #abseil-cpp
  ];
    buildInputs = [
    #hunspell
    #poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    (import ./kde-extra-cmake-modules.nix)
    python313
    python312
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
