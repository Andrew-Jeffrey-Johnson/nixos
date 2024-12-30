
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "karchive";
  version = "6.9.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "9f4f5e2655e2fa043886ed373730dcedc2dec4e9";
    sha256 = "sha256-doDYYGZ8kbtEXCXGlpolYWONGl3zmKFkGpovMe2bmGw=";
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
    xz
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
