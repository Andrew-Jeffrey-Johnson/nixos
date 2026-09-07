{ pkgs }: {
  name = "lutris";
  game = true;
  free = true;
  #systemSettings = { };
  homeSettings = {
    enable = true;
    winePackages = [ pkgs.wineWow64Packages.full ];
    protonPackages = [ pkgs.proton-ge-bin ];
    defaultWinePackage = pkgs.proton-ge-bin;
    steamPackage = pkgs.steam;
  };
}
