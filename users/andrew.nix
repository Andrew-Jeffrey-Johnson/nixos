{
  pkgs,
  andrewEnabled,
  ...
}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  andrew =
    if andrewEnabled then
      [
        {
          isNormalUser = true;
          description = "Andrew Johnson";
          extraGroups = [
            "networkmanager"
            "wheel"
            "input"
            "docker"
            "libvirtd"
            "adbusers"
            "fuse"
          ];
          shell = pkgs.zsh;
        }
      ]
    else
      [ ];
}
