{ pkgs }: [
  pkgs.kitty # Terminal
  pkgs.wget # Get web pages
  pkgs.nix-index # Search for nix packages
  pkgs.manix # Nix documentation
  pkgs.wl-clipboard-rs # Terminal clipboard
  pkgs.catppuccin # Many color themes
  pkgs.jdk25 # Java
  pkgs.wordbook # English Dictionary
  pkgs.trash-cli # Command-line trash
  pkgs.duckdb # Stores commands from cli
  pkgs.sqlite # Database as a file
  pkgs.gamescope # For steam games
  pkgs.blender
  pkgs.luanti # FOSS Minecraft
  pkgs.waypipe # Enables application forwarding on Wayland similar to ssh -X
  pkgs.godot # Game development
  pkgs.kdePackages.ksystemlog # Desktop environment event viewer
  pkgs.tor-browser
  pkgs.discord
  pkgs.prismlauncher # Minecraft
  pkgs.qalculate-qt # Calculator
  pkgs.qbittorrent # Torret
  pkgs.chromium # Open-source portion of chrome
  pkgs.gimp # Rastor Image Editor
  pkgs.audacity # Audio Editor
  pkgs.inkscape # Vector Image Editor
  pkgs.vlc # Media player
  pkgs.mpv # Media player
  pkgs.sshfs # Mount
  pkgs.pgadmin4 # Server that hosts a website to view PostgreSQL database
  pkgs.zoom-us

  # Screen recording
  pkgs.obs-studio
  pkgs.obs-do
  pkgs.obs-cmd
  pkgs.obs-cli

  # Office Programs
  pkgs.libreoffice-fresh # Office suite
  pkgs.hunspell # Spell-checker for libreoffice
  pkgs.hunspellDicts.en_US-large # English dictionary for hunspell

  # LaTeX Editor
  pkgs.texstudio
  pkgs.texliveFull
  pkgs.poppler # PDF viwer used by texstudio

  # Command-line Esperanto dictionary
  pkgs.prevo-tools
  pkgs.prevo-data

  # Compression programs
  pkgs._7zz
  pkgs.rar
  pkgs.unzip
]
