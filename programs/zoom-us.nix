{
  pkgs,
  allowUnfree,
  zoom-usDesired,
  ...
}:
{
  # Packages to install
  packages = if allowUnfree && zoom-usDesired then [ pkgs.zoom-us ] else [ ]; # Purposefully empty

  # Steam has a restrictive license. Allow it just for Steam.
  allowUnfreePredicate =
    if allowUnfree && zoom-usDesired then
      [
        pkgs.zoom-us
      ]
    else
      [ ]; # Purposefully empty
}
