with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "extra-cmake-modules";
  version = "6.9.0";
  src = fetchurl {
    url = "https://invent.kde.org/frameworks/extra-cmake-modules/-/archive/v6.9.0/extra-cmake-modules-v6.9.0.tar.gz";
    hash = "sha256-jMlwsmSGcyt1e8kucUYCH7pH3lMO0LyexJVbM+njRdI=";
    #hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
    nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
    libtorrent-rasterbar
    boost
  ];
    buildInputs = [
    hunspell
    poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
