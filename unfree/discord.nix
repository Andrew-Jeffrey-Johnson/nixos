{
  pkgs,
  lib,
  ...
}:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = [
    pkgs.steam
    pkgs.steam-original
    pkgs.steam-run
  ];

  #nixpkgs.config.allowUnfreePredicate =
  #  pkg:
  #  builtins.elem (lib.getName pkg) [
  #    "steam"
  #    "steam-original"
  #    "steam-run"
  #  ];
}
