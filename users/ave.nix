{
  pkgs,
  aveEnabled,
  ...
}:
let
  value = {
    enable = true;
    name = "ave";
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
  };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  ave =
    if aveEnabled then
      [
        {
          name = "ave";
          value = value;
        }
      ]
    else
      [ ];
}
