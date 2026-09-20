let
  andrew = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITtbxIQQEew/ZSIoxW67DCdrISTyg0fg7ndYTlXO54F"; # andrew.jeffrey.johnson@gmail.com
  users = [
    andrew
  ];

  # Remember that the public host key of each system is NOT the ssh key of root.
  # It's stored in /etc/ssh. It's called ssh_host_*_key.pub
  luminlapid-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/ReINE3OhdJjY1/J6t8r4Tou/kvxvCZe7h0h5scGC/"; # root@luminlapid-server
  andrews-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxQ74pXL4bTRGPK+e5aDZbvnMXwgpHK4zxE+yJ4jO+R"; # root@nixos
  aves-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACaE4GctlrB4HmgBZ708E/nsQpUqbEgfNIIMWV2HD3o"; # root@Aves-desktop
  systems = [
    luminlapid-server
    andrews-desktop
    aves-desktop
  ];
in
{
  "wireguard-private-key.age".publicKeys = users ++ systems;
  "samba-server-nixos.age".publicKeys = users ++ systems;
}
