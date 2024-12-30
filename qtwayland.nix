
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "qtwayland";
  version = "6.8.1";
  src = pkgs.fetchFromGitHub {
    owner = "qt";
    repo = "${name}";
    rev = "fb472225982100a8da56aeb5f8500e61012a1508";
    sha256 = "sha256-mgli3a0pZvDkpoP/6EdaD+/597XzBwluguI9/G6JR/E=";
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
    (import ./qtbase.nix)
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
    (import ./qtbase.nix)
    python313
    python312
    zlib
    xz
  ] ++ lib.optionals stdenv.isLinux [

  ];
}
