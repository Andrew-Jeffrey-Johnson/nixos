{
  pkgs,
  allowUnfree,
  gamesDesired,
  ...
}:
let
  # Packages that do not have a permissive license
  restrictive = if gamesDesired && allowUnfree then [ ] else [ ]; # Purposefully empty
  # FOSS and Permissive Packages
  permissive =
    if gamesDesired then
      [
        # For Lutris games
        pkgs.wineWow64Packages.fonts
      ]
    else
      [ ]; # Purposefully empty
in
{
  steam = {
    enable = if gamesDesired && allowUnfree then true else false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
  };

  lutris = {
    enable = if gamesDesired then true else false;
    winePackages = [ pkgs.wineWow64Packages.full ];
    protonPackages = [ pkgs.proton-ge-bin ];
    defaultWinePackage = pkgs.proton-ge-bin;
    steamPackage = pkgs.steam;
  };

  # Packages to install
  packages = restrictive ++ permissive; # Purposefully empty

  # Steam has a restrictive license. Allow it just for Steam.
  allowUnfreePredicate =
    if gamesDesired && allowUnfree then
      [
        "steam"
        "steam-unwrapped"
        "steam-original"
        "steam-run"
      ]
    else
      [ ]; # Purposefully empty
}
