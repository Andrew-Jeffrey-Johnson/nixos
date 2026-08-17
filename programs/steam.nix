{
  pkgs,
  steamDesired,
  allowUnfree,
  gamesDesired,
  ...
}:
let
  # Packages that do not have a permissive license
  restrictive = if steamDesired && gamesDesired && allowUnfree then [ ] else [ ]; # Purposefully empty
  # FOSS and Permissive Packages
  permissive =
    if steamDesired && gamesDesired then
      [
        # For Lutris games
        pkgs.wineWow64Packages.fonts
      ]
    else
      [ ]; # Purposefully empty
in
{
  steam = {
    enable = if steamDesired && gamesDesired && allowUnfree then true else false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
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
