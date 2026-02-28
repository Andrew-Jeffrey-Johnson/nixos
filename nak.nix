builtins.derivation {
  # A name for the derivation (whatever you choose)
  name = "NaK";
  # The system realising the derivation
  system = "x86_64-linux";
  # The program realising the derivation
  builder = "bash";
  src = pkgs.fetchFromGitHub {
    owner = "SulfurNitride";
    repo = "NaK";
    rev = "23a61ecde67b1e09dc7c383536d6a0c12be1e929";
    sha256 = "sha256-QzEiCkWNeo0vAsx1UizAjXMDDJkmH1IlVVdDMo6sYmQ=";
    #rev = "6af666087fec63c6cb2a8747f69688631abe1e5d";
    #sha256 = "sha256-gGL9eM0OsUg34GXFsz5LJ738WSl8L8mGfOcZZPNceT4=";
  };
}
