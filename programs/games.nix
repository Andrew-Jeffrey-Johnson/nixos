{
  pkgs,
  allowUnfree,
  gamesDesired,
  ...
}:
{
  programs.steam = {
    enable = if gamesDesired && allowUnfree then true else false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
  };

  # Packages to install
  packages = if gamesDesired && allowUnfree then [ ] else [ ]; # Purposefully empty

  # Steam has a restrictive license. Allow it just for Steam.
  allowUnfreePredicate =
    if gamesDesired && allowUnfree then
      [
        pkgs.steam
        pkgs.steam-original
        pkgs.steam-run
      ]
    else
      [ ]; # Purposefully empty
}
