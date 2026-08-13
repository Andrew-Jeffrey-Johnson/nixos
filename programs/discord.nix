{
  pkgs,
  allowUnfree,
  discordDesired,
  ...
}:
{
  # Packages to install
  packages = if allowUnfree && discordDesired then [ pkgs.discord ] else [ ]; # Purposefully empty

  # Steam has a restrictive license. Allow it just for Steam.
  allowUnfreePredicate =
    if allowUnfree && discordDesired then
      [
        pkgs.discord
      ]
    else
      [ ]; # Purposefully empty
}
