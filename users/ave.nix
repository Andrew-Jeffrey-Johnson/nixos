{
  pkgs,
  aveEnabled,
  ...
}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  ave =
    if aveEnabled then
      [
        {
          isNormalUser = true;
          description = "Avery Littman";
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
