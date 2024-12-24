# Build in terminal with:
# sudo nix-build texstudio.nix

with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "texstudio";
  version = "4.8.4";

  #   # https://github.com/tembo-io/pgmq/
  src = pkgs.fetchFromGitHub {
    owner = "texstudio-org";
    repo = "${name}";
    rev = "73888512cf0c5364f6eb6c0574ba218061eb1b9f";
    sha256 = "sha256-QzEiCkWNeo0vAsx1UizAjXMDDJkmH1IlVVdDMo6sYmQ=";
    #rev = "6af666087fec63c6cb2a8747f69688631abe1e5d";
    #sha256 = "sha256-gGL9eM0OsUg34GXFsz5LJ738WSl8L8mGfOcZZPNceT4=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [
    hunspell
    poppler
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];

#  prePatch = ''
#
 # '';
 # configurePhase = ''
 #   source $stdenv/setup
 #   mkdir build
 #   cd build
 # '';
 # buildPhase = ''
 #   cmake ..
 #   cmake --build . --parallel 12
 #'';
  #installPhase = ''
  #  cmake --install . --prefix $out
  #'';
}
