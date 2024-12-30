
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "kcrash";
  version = "6.9.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "84ebb912f8ea74fa57435ec973aa1ba075ba558d";
    sha256 = "sha256-scfWOdhuUmOI5yf8j82HZfuxz/14D6w1wIDNJI+qn1k=";
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
    libtorrent-rasterbar
    boost
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
    (import ./kcoreaddons.nix)
    python313
    python312
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
