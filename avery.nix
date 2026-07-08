{
  users = {
    groups.docker = { };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.avery = {
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
    };
  };
}
