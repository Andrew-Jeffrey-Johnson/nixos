{
  pkgs,
  andrewEnabled,
  ...
}:
let
  value = {
    enable = true;
    name = "andrew";
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
  };
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  andrew =
    if andrewEnabled then
      [
        {
          name = "andrew";
          value = value;
        }
      ]
    else
      [ ];
}
