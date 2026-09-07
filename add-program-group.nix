{ programFilePath }:
let
  program = import programFilePath;
  has = name: builtins.hasAttr name program;
in
{
  # If there are inputs to be added to the input section of the flake, specify a set here
  flakes = if has "flakes" then program.flakes else { };

  # The program has a restrictive license if the unfreePredicate is set
  unfreePredicate = if has "unfreePredicate" then program.unfreePredicate else [ ];

  # By default, assume programs are not for games
  isGame = if has "isGame" then program.game else false;

  # By default, assume programs are safe for work
  isSfw = if has "isSfw" then program.sfw else true;

  # Configuration settings and home manager settings
  systemSettings = if has "systemSettings" then program.systemSettings else { };
  homeSettings = if has "homeSettings" then program.homeSettings else { };

  packages = if has "packages" then program.packages else [ ];
}
