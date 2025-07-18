{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1080@60.00Hz, 0x0, 1" # Built-in monitor 
      "HDMI-A-2, 1920x1080@59.79Hz, 1920x0, 1" # External TV monitor
    ];
    opengl = {
      nvidia_anti_flicker = false;
    };
    "$mod" = "SUPER";# Sets "Windows" key as main modifier
    # See https://wiki.hyprland.org/Configuring/Keywords/
    "$terminal" = "kitty";
    "$fileManager" = "yazi";
    "$menu" = "wofi --show drun";
    exec-once = [
      
    ];
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      # Put cards in order
      "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card2:/dev/dri/card0" 
      # List devices:
      # lspci -d ::03xx
      # Figure out which card is for which device: 
      # ls -l /dev/dri/by-path
    ];
    # Refer to https://wiki.hyprland.org/Configuring/Variables/
    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
      "gaps_in" = 5;
      "gaps_out" = 20;
      "border_size" = 2;
      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      "resize_on_border" = "false";

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      "allow_tearing" = "false";

      "layout" = "dwindle";
    };
    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    #decoration = {
        #"rounding" = 0; # Default = 10
        #"rounding_power" = 0; # Default = 0

        # Change transparency of focused and unfocused windows
        #"active_opacity" = 1.0;
        #"inactive_opacity" = 1.0;

        #shadow = {
        #    "enabled" = false; # Changed to false
        #    "range" = 4;
        #    "render_power" = 3;
        #    "color" = "rgba(1a1a1aee)";
        #};

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        #blur = {
        #    "enabled" = false; # Changed to false
        #    "size" = 3;
        #    "passes" = 1;#
        #    "vibrancy" = 0.1696;
        #};
    #};
    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = "no"; # Default = "yes"
      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];
      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        "workspacesIn, 1, 1.21, almostLinear, fade"
        "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };
    # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
    # "Smart gaps" / "No gaps when only"
    # uncomment all if you wish to use that.
    # workspace = w[tv1], gapsout:0, gapsin:0
    # workspace = f[1], gapsout:0, gapsin:0
    # windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
    # windowrule = rounding 0, floating:0, onworkspace:w[tv1]
    # windowrule = bordersize 0, floating:0, onworkspace:f[1]
    # windowrule = rounding 0, floating:0, onworkspace:f[1]

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      vfr = true; # Added by me
    };

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
          natural_scroll = false;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = false;
    };

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
    device = {
      name = "epic-mouse-v1";
      sensitivity = -0.5;
    };

    bind = [
      "$mod, F, exec, firefox"
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mod, Q, exec, $terminal"
      "$mod, C, killactive,"
      "$mod, M, exit,"
      "$mod, E, exec, $fileManager"
      "$mod, V, togglefloating,"
      "$mod, R, exec, $menu"
      "$mod, P, pseudo," # dwindle
      "$mod, J, togglesplit," # dwindle
      # Move focus with mainMod + arrow keys
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      ", Print, exec, grimblast copy area"
      # Example special workspace (scratchpad)
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"
      # Scroll through existing workspaces with mod + scroll
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
    );
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bindel = [
      # Laptop multimedia keys for volume and LCD brightness
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];
    bindl = [
      # Requires playerctl
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

    # Example windowrule
    # windowrule = float,class:^(kitty)$,title:^(kitty)$

    
    windowrule = [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppressevent maximize, class:.*"
      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ 
        "/home/andrewj/Pictures/wallpapers/forest-wallpaper.jpg"
      ];
      wallpaper = [
        ", /home/andrewj/Pictures/wallpapers/forest-wallpaper.jpg"
      ];
    };
  };
}
