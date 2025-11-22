let
  pkgs =
    import
      (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f0d925b947cca0bbe7f2d25115cbaf021844aba7.tar.gz")
      { config.allowUnfree = true; };
in
pkgs.python3Packages.buildPythonApplication {
  pname = "utf-cli";
  version = "2024-07-11";
  pyproject = true;
  src = pkgs.fetchFromGitHub {
    owner = "treyhunner";
    repo = "utf-cli";
    rev = "2a3500230af59ee0dd6b0021b3a79883a4d6e34d";
    sha256 = "sha256-ZrF4VCOYB7Mtes1QDg+YE0z2yT25m9/Y0AIKswm6BTI=";
  };
  propagatedBuildInputs = [
    pkgs.python312Packages.hatchling
    pkgs.python312Packages.textual-dev
    pkgs.python312Packages.pyperclip
    pkgs.python312Packages.platformdirs
    pkgs.python312Packages.darkdetect
    pkgs.python312Packages.qtpy
  ];
  doCheck = false;
  meta = with pkgs.lib; {
    description = ''
      A CLI unicode emoji search engine.
    '';
    mainProgram = "utf";
    homepage = "https://github.com/treyhunner/utf-cli";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
