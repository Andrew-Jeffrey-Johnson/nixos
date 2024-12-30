 
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "korganizer";
  version = "24.12.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "9bbf2f8e9008837b375827fe244c525bc5682de7";
    sha256 = "sha256-SPGjpLzJ/NN9iUG3gp3o19B4DEhndtUHRxapL7Ac5TM=";
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
    kdePackages.sonnet
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    (import ./kde-extra-cmake-modules.nix)
    (import ./ki18n.nix)
    (import ./kconfig.nix)
    (import ./kcoreaddons.nix)
    (import ./kcrash.nix)
    (import ./karchive.nix)
    (import ./kiconthemes.nix)
    (import ./kcolorscheme.nix)
    (import ./kguiaddons.nix)
    (import ./plasma-wayland-protocols.nix)
    python313
    python312
    zlib
    xz
  ];
    buildInputs = [
    hunspell
    poppler
    kdePackages.sonnet
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    (import ./kde-extra-cmake-modules.nix)
    (import ./ki18n.nix)
    (import ./kconfig.nix)
    (import ./kcoreaddons.nix)
    (import ./kcrash.nix)
    (import ./karchive.nix)
    (import ./kiconthemes.nix)
    (import ./kcolorscheme.nix)
    (import ./kguiaddons.nix)
    (import ./plasma-wayland-protocols.nix)
    python313
    python312
    zlib
    xz
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
