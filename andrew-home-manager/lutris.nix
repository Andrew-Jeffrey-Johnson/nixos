{
  pkgs,
  osConfig,
  ...
}:
{
  programs.lutris = {
    enable = true;
    winePackages = [ pkgs.wineWow64Packages.full ];
    protonPackages = [ pkgs.proton-ge-bin ];
    defaultWinePackage = pkgs.proton-ge-bin;
    steamPackage = osConfig.programs.steam.package;
  };
}
