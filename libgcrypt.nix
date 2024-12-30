
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "libgcrypt";
  version = "1.11.0";
  src = pkgs.fetchFromGitHub {
    owner = "gpg";
    repo = "${name}";
    rev = "9d94d7846cde272b8b1519ba96e53967bf0b90d2";
    sha256 = "sha256-B+bGPxNjYtzoq6Rnfd9QWuV8ibMIujnwNkr3bpE9oHY=";
    #sha256 = "sha256-n0JGQ+zrL+9RZP9edBCEFxhZBRH6962vMEp/I2qeLlQ=";
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
    python313
    python312
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
