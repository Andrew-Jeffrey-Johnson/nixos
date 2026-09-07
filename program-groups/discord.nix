{ pkgs }: {
  isGame = true;
  unfreePredicate = [
    "discord"
    "discord-unwrapped"
  ];
  # Packages to install
  packages = [ pkgs.discord ];
}
