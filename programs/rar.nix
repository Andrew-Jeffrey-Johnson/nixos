{
  pkgs,
  allowUnfree,
  rarDesired,
  ...
}:
{
  # Packages to install
  packages = if allowUnfree && rarDesired then [ pkgs.rar ] else [ ]; # Purposefully empty

  # Steam has a restrictive license. Allow it just for Steam.
  allowUnfreePredicate =
    if allowUnfree && rarDesired then
      [
        "rar"
      ]
    else
      [ ]; # Purposefully empty
}
