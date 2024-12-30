
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "plasma-wayland-protocols";
  version = "1.15.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "14559ba7e645eee637b8b43e4c63616b4e29a2a2";
    sha256 = "sha256-E+e9peabP6xVRrGlNRezmiLzQAIKhYdDM3zlQC9sYJ8=";
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
    (import ./kconfig.nix)
    python313
    python312
    zlib
    xz
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
