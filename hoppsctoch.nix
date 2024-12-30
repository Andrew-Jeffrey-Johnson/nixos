
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "hoppscotch";
  version = "2024.12.0";
  src = pkgs.fetchFromGitHub {
    owner = "hoppscotch";
    repo = "${name}";
    rev = "a16402e94d9bb1e753296210b9c337e92cc666d0";
    sha256 = "sha256-Y2DILCccbmP7BaJEU9mSTj9tjMRafGji46rOLoVmWmk=";
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  nativeBuildInputs = [
    ninja
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
    python312
    zlib
    xz
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
