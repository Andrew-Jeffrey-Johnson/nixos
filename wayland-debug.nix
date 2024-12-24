with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "wayland-debug";
  version = "1.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "wmww";
    repo = "${name}";
    rev = "98c04c4e1bbfb3bf1fa8de167283e8398d3e29e7";
    sha256 = "sha256-iwqJaRfwJTL6SimWTNqqqFPXxSKrgo6whYY70llZyGs=";
  };
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
    libtorrent-rasterbar
    boost
    meson
  ];
    buildInputs = [
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
