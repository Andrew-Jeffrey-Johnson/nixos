with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "wireshark";
  version = "4.2.9";
  src = fetchurl {
    url = "https://gitlab.com/wireshark/wireshark/-/archive/2acaabc9099cb3d7e5715776e00068ccfd07ac58/wireshark-2acaabc9099cb3d7e5715776e00068ccfd07ac58.tar.gz";
    hash = "sha256-az4/xu+/iyLIA5N863hwHkxQ3eolXLFz8QTY177HC0A=";
  };
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
    pkg-config
    libtorrent-rasterbar
    boost
    (import ./libgcrypt.nix)
    libgcrypt
    #sbclPackages.cl-gcrypt
    ##sbclPackages.cl-gcrypt-test
    c-ares
    flex
    speexdsp
    kdePackages.qtmultimedia
    git
    libssh
    pcapc
    libmaxminddb
    libsmi
    gnutls
    krb5
    zlib
    lz4
    snappy
    nghttp2
    lua
    libnl
    sbc
    spandsp
    spandsp3
    bcg729
    opencore-amr
    (import ./libilbc.nix)
    opusTools
    opustags
    opusfile
    libcap
    doxygen
    asciidoctor-with-extensions
    nghttp3
  ];
    buildInputs = [
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.quazip
    (import ./kde-extra-cmake-modules.nix)
    (import ./libgcrypt.nix)
    libgcrypt
    #sbclPackages.cl-gcrypt
    #sbclPackages.cl-gcrypt-test
    python313
    python312
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.qtwayland
  ];
}
