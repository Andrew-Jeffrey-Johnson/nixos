
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "qtbase";
  version = "6.8.1";
  src = pkgs.fetchFromGitHub {
    owner = "qt";
    repo = "${name}";
    rev = "0db4321f2f13c6870283f3fcc0f1a462fd7cf663";
    sha256 = "sha256-DJow6Dl1yn0IipHSAHYaxIvZkf+pINDi7lXjp+w6CF0=";
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  nativeBuildInputs = [
    ninja
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
    libtorrent-rasterbar
    boost
    hunspell
    poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    (import ./kde-extra-cmake-modules.nix)
    (import ./kcoreaddons.nix)
    (import ./kconfig.nix)
    (import ./plasma-wayland-protocols.nix)
    (import ./qtwayland.nix)
    python313
    python312
    zlib
    xz
  ];
    buildInputs = [
    hunspell
    poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    (import ./kde-extra-cmake-modules.nix)
    (import ./kcoreaddons.nix)
    (import ./kconfig.nix)
    (import ./plasma-wayland-protocols.nix)
    python313
    python312
    zlib
    xz
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
    (import ./qtwayland.nix)
  ];
}
