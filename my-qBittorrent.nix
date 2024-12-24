with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "qBittorrent";
  version = "5.0.0";
  src = pkgs.fetchFromGitHub {
    owner = "qbittorrent";
    repo = "${name}";
    rev = "cce295faeb27ebf9d57498ac5e35490c845b9d4f";
    sha256 = "sha256-iwqJaRfwJTL6SimWTNqqqFPXxSKrgo6whYY70llZyGs=";
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
