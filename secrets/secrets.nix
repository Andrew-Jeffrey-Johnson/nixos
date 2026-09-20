let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITtbxIQQEew/ZSIoxW67DCdrISTyg0fg7ndYTlXO54F"; # andrew.jeffrey.johnson@gmail.com
  users = [ user1 ];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/ReINE3OhdJjY1/J6t8r4Tou/kvxvCZe7h0h5scGC/"; # root@nixos
  systems = [ system1 ];
in
{
  "secret1.age".publicKeys = [
    user1
    system1
  ];
  "wireguard-private-key.age".publicKeys = [
    user1
    system1
  ];
  "samba-server-nixos.age".publicKeys = [
    user1
    system1
  ];
}
