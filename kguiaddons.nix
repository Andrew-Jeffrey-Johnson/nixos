
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "kguiaddons";
  version = "6.9.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "a76b0148f956156fafa27677309526a5353483e6";
    sha256 = "sha256-NW+NTbCwlGnYcKkUAsPLUKdjQXuErVaC2N3NoMQZK1I=";
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
    (import ./qtbase.nix)
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
  ];
    buildInputs = [
    hunspell
    poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    (import ./qtbase.nix)
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
    #kdePackages.qtwayland
    (import ./qtwayland.nix)
  ];
}
