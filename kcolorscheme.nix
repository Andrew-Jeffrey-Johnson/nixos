
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "kcolorscheme";
  version = "6.9.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "aa255466c02993240a621eeabfce078a217bbe39";
    sha256 = "sha256-RlOX1evVscXzjjTMd/vyawqGJ+j99rgn57sORBXPhR8=";
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
    (import ./kguiaddons.nix)
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
    (import ./kguiaddons.nix)
    python313
    python312
    zlib
    xz
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
    (import ./qtwayland.nix)
  ];
}
