{
  pkgs,
  lutrisDesired,
  gamesDesired,
  ...
}:
{
  programs.lutris = {
    enable = if lutrisDesired && gamesDesired then true else false;
    winePackages = [ pkgs.wineWow64Packages.full ];
    protonPackages = [ pkgs.proton-ge-bin ];
    defaultWinePackage = pkgs.proton-ge-bin;
    steamPackage = pkgs.steam;
  };
}
