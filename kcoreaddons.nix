
with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "kcoreaddons";
  version = "6.9.0";
  src = pkgs.fetchFromGitHub {
    owner = "KDE";
    repo = "${name}";
    rev = "ac832c5e07cb0cc5aa83467e82e6146a8d8b4c1f";
    sha256 = "sha256-Er9xH0WfXQJukUpb+Fq3jcwP9lE5RP9SHo6yY6FaxGI=";
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
    python313
    python312
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
