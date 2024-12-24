with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  name = "DND-5e-LaTeX-Template";
  version = "0.8.0";

  # https://github.com/rpgtex/DND-5e-LaTeX-Template.git
  src = pkgs.fetchFromGitHub {
    owner = "rpgtex";
    repo = "${name}";
    rev = "2c94ab97952b8285bbbc932ccd507cbcd931ef82";
    sha256 = "sha256-QzEiCkWNeo0vAsx1UizAjXMDDJkmH1IlVVdDMo6sYmQ=";
    #rev = "6af666087fec63c6cb2a8747f69688631abe1e5d";
    #sha256 = "sha256-gGL9eM0OsUg34GXFsz5LJ738WSl8L8mGfOcZZPNceT4=";
  };

}
