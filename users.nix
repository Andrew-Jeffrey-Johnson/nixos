{
  users = {
    groups.docker = { };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.andrew = {
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
    };
  };
}
