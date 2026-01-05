{ config, pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      monitor = [
        ", preferred, auto, 1"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      exec-once = [
        # "quickshell"
        # "hyprshell run &"
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd &"
        "sleep 1 & dbus-update-activation-environment --systemd WAYLAND_DISPLAY & XDG_CURRENT_DESKTOP &"
        "~/.config/hypr/autostart &"
        "gsettings set org.gnome.desktop.interface cursor-theme Banana"
        "gsettings set org.gnome.desktop.interface cursor-size 40"
        "waybar -c .config/waybar/config -s .config/waybar/style.css"
        "mako &"
        "wl-paste -w cliphist store"
        "swayidle -w timeout 180 '$lock' timeout 210 'systemctl suspend' before-sleep '$lock' &"
        "bash -c \"mkfifo /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob && tail -f /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob | wob & disown\""
        # "lxqt-policykit-agent &"
        "hyprpolkitagent &"
        "swww query || swww init"
        "waypaper --restore"
        "~/.config/mako/update-theme.sh"
        "clipse -listen &"
        "bongocat --config ~/.config/bongocat.conf"
        "hyprctl setcursor Banana 40"
        "vicinae server"
        # "ags &"
      ];

      env = [
        "XCURSOR_SIZE,40"
        "HYPRCURSOR_SIZE,40"
        "HYPRCURSOR_THEME,Banana"
        "WLR_DRM_NO_ATOMIC,1"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "QT_QPA_PLATFORM,wayland;xcb"
        "GDK_BACKEND,wayland,x11"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      input = {
        kb_layout = "us";
        kb_options = "grp:caps_toggle,grp_led:caps,ctrl:rctrl_ralt";
        accel_profile = "flat";
        follow_mouse = 1;
        float_switch_override_focus = 2;
        touchpad = {
          disable_while_typing = true;
          natural_scroll = true;
          scroll_factor = 1.5;
          drag_lock = 0;
        };
        touchdevice = {
          enabled = false;
        };
        sensitivity = 0;
      };

      general = {
        gaps_in = 3;
        gaps_out = 4;
        border_size = 3;
        "col.active_border" = "0xffcba6f7 0xff89b4fa 45deg";
        "col.inactive_border" = "0xff6c7086";
        extend_border_grab_area = 15;
        layout = "master";
      };

      debug = {
        disable_logs = false;
      };

      decoration = {
        active_opacity = 0.98;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        rounding = 0;
        dim_inactive = false;
        blur = {
          size = 8;
          passes = 4;
          new_optimizations = true;
          ignore_opacity = false;
          xray = true;
          noise = 0.025;
          contrast = 1;
          vibrancy = 0.3;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.5, 0, 0.99, 0.99"
          "smoothIn, 0.5, -0.5, 0.68, 1.5"
        ];
        animation = [
          "windows, 1, 5, overshot, slide"
          "windowsOut, 1, 3, smoothOut"
          "windowsIn, 1, 3, smoothOut"
          "windowsMove, 1, 4, smoothIn, slide"
          "border, 1, 5, default"
          "fade, 1, 5, smoothIn"
          "fadeDim, 1, 5, smoothIn"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        force_split = 0;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
        special_scale_factor = 0.8;
        orientation = "left";
        new_on_top = true;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = false;
        animate_manual_resizes = false;
        enable_swallow = false;
        focus_on_activate = true;
        vfr = true;
      };

      # gestures = {
      #   workspace_swipe_distance = 250;
      #   workspace_swipe_invert = true;
      #   workspace_swipe_min_speed_to_force = 15;
      #   workspace_swipe_cancel_ratio = 0.15;
      #   workspace_swipe_create_new = true;
      # };

      binds = {
        workspace_back_and_forth = true;
        allow_workspace_cycles = true;
      };

      cursor = {
        hide_on_key_press = true;
        enable_hyprcursor = true;
      };

      # Variables from original config
      "$mainMod" = "SUPER";
      "$backlight" = "~/.config/hypr/scripts/brightness";
      "$lock" = "~/.config/hypr/scripts/lockscreen";
      "$screenshot" = "~/.config/hypr/scripts/screenshot";
      "$screenshot_area" = "~/.config/hypr/scripts/screenshot_area";
      "$screenshot_full" = "~/.config/hypr/scripts/screenshot_full";

      bind = [
        "$mainMod, X, killactive,"
        "$mainMod, V, togglefloating,"
        # "ALT, SPACE, exec, qs msg shell send 'togglelauncher'"
        "ALT, SPACE, exec, rofi -show"
        "CTRL, SPACE, exec, vicinae toggle"
        # "ALT, TAB, exec, rofi -show window"
        # "ALT, TAB, hyprexpo:expo, toggle"
        "ALT, C, exec, /home/iroh/flare_0.1.0_amd64.AppImage"
        "$mainMod, F, fullscreen"
        "$mainMod SHIFT, F, exec, hyprctl dispatch fullscreen 1"
        "$mainMod, Y, pin"
        "$mainMod, J, togglesplit,"
        "$mainMod, K, togglegroup,"
        "$mainMod, Tab, changegroupactive, f"
        "$mainMod, C, changegroupactive"
        "$mainMod, R, moveoutofgroup"
        "CTRL ALT, L, lockgroups, lock"
        "CTRL ALT, L, lockgroups, unlock"
        ", XF86AudioLowerVolume, exec, pamixer -ud 3 && pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
        ", XF86AudioRaiseVolume, exec, pamixer -ui 3 && pamixer --get-volume > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
        ", XF86AudioMute, exec, pamixer -t | sed -En '/\\[on\\]/ s/.*\\[([0-9]+)%\\]/\\1/ p; /\\[off\\]/ s/.*/0/p' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, $backlight --inc"
        ", XF86MonBrightnessDown, exec, $backlight --dec"
        "CTRL ALT, B, exec, bongocat --toggle --config ~/.config/bongocat.conf"
        "SUPER, U, exec, hyprfreeze -a"
        "CTRL ALT, T, exec, kitty fish"
        "CTRL ALT, E, exec, nautilus"
        "CTRL ALT, Q, exec, qutebrowser"
        "SUPER, escape, exec, wlogout"
        "CTRL ALT, R, exec, kitty ranger"
        "$mainMod, L, exec, $lock"
        ", Print, exec, $screenshot"
        "CTRL, Print, exec, $screenshot_full"
        "CTRL ALT, C, exec, ~/.config/hypr/scripts/wallpaper.sh"
        "CTRL ALT, S, exec, ~/.config/hypr/grayscale.sh"
        # "SUPER, TAB, exec, ~/.config/rofi/rofi-edit"
        "CTRL SHIFT, C, exec, ~/.config/rofi/wall select"
        "SUPER, P, exec, kitty --class clipse -e 'clipse'"
        "$mainMod, O, exec, killall -SIGUSR1 .waybar-wrappd"
        "SUPER, 0, exec, hyprctl reload"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, period, workspace, e+1"
        "$mainMod, comma, workspace, e-1"
        "$mainMod, minus, movetoworkspace, special"
        "$mainMod, equal, togglespecialworkspace"
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod CTRL, 1, movetoworkspace, 1"
        "$mainMod CTRL, 2, movetoworkspace, 2"
        "$mainMod CTRL, 3, movetoworkspace, 3"
        "$mainMod CTRL, 4, movetoworkspace, 4"
        "$mainMod CTRL, 5, movetoworkspace, 5"
        "$mainMod CTRL, 6, movetoworkspace, 6"
        "$mainMod CTRL, 7, movetoworkspace, 7"
        "$mainMod CTRL, 8, movetoworkspace, 8"
        "$mainMod CTRL, 9, movetoworkspace, 9"
        "$mainMod CTRL, 0, movetoworkspace, 10"
        "$mainMod CTRL, left, movetoworkspace, -1"
        "$mainMod CTRL, right, movetoworkspace, +1"
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, slash, workspace, previous"
        "$mainMod, s, exec, scratchpad"
        "SUPERSHIFT, s, exec, scratchpad -g"
        "$mainMod, enter, layoutmsg, swapwithmaster master"
      ];

      bindm = [
        "ALT, mouse:272, resizewindow"
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindc = [
        "ALT, mouse:273, exec, hyprctl dispatch fullscreen 1"
      ];

      bindr = [
        "CTRL ALT, P, exec, pkill waybar || waybar -c .config/waybar/config -s .config/waybar/style.css"
      ];

      windowrulev2 = [
        "size 622 652,initialClass:clipse"
        "move 653 218,initialClass:clipse"
        "float,initialClass:clipse"
        "float,title:Rofi"
        "float,class:Volume Control"
        "float,class:youtube,title:Picture in picture"
        "float,class:brave,title:Save File"
        "float,class:brave,title:Open File"
        "float,class:LibreWolf,title:Picture-in-Picture"
        "float,class:blueman-manager"
        "float,class:xdg-desktop-portal-gtk"
        "float,class:xdg-desktop-portal-kde"
        "float,class:org.kde.polkit-kde-authentication-agent-1"
        "float,title:Picture-in-Picture"
        "size 960 540,title:Picture-in-Picture"
        "move 25%-,title:Picture-in-Picture"
        "float,title:imv"
        "opaque,title:mpv"
        "opaque,title:Caido"
        "float,title:blueberry"
        "move 25%-,title:mpv"
        "size 960 540,title:mpv"
        "animation slide right,title:kitty"
        "animation slide right,title:alacritty"
        "opaque,title:firefox"
        "float,title:Search Youtube"
        "float,title:Ark"
        "float,title:PhotoQt Image Viewer"
        "float,title:Java"
        "tile,title:burp-StartBurp"
      ];

      plugin = {
        hyprscrolling = {
          column_width = 0.7;
          explicit_column_widths = "0.333,0.5,0.667,1.0";
          focus_fit_method = 0;
          fullscreen_on_one_column = true;
        };

        dynamic-cursors = {
          enabled = true;
          mode = "tilt";
          threshold = 2;
          tilt = {
            limit = 5000;
            function = "negative_quadratic";
            window = 100;
          };
          stretch = {
            limit = 3000;
            function = "quadratic";
            window = 100;
          };
          rotate = {
                length = 40;
                offset = 0.0;
            };
          shake = {
            enabled = true;
            nearest = true;
            threshold = 4.0;
            base = 3.0;
            speed = 4.0;
            influence = 0.0;
            limit = 4.0;
            timeout = 400;
            effects = false;
            ipc = false;
          };
          hyprcursor = {
            nearest = true;
            enabled = true;
            resolution = -1;
            fallback = "clientside";
          };
        };

        # hyprexpo = {
        #   columns = 3;
        #   gap_size = 5;
        #   bg_col = "rgb(111111)";
        #   workspace_method = "center current";
        #   gesture_distance = 300;
        # };
    #     hyprtasking = {
    #         layout = "grid";
    #         gap_size = 20;
    #         bg_color = "0xff26233a";
    #         border_size = 4;
    #         exit_on_hovered = false;
    #         warp_on_move_window = 1;
    #         close_overview_on_reload = true;
    # 
    #         drag_button = "0x110"; # left mouse button
    #         select_button = "0x111"; # right mouse button
    #         # for other mouse buttons see <linux/input-event-codes.h> 
    #         gestures = {
    #             enabled = true;
    #             move_fingers = 3;
    #             move_distance = 300;
    #             open_fingers = 4;
    #             open_distance = 300;
    #             open_positive = true;
    #         };
    #         grid = {
    #             rows = 3;
    #             cols = 3;
    #             loop = false;
    #             gaps_use_aspect_ratio = false;
    #         };
    #         linear = {
    #             height = 400;
    #             scroll_speed = 1.0;
    #             blur = false;
    #         };
    #     };
      };
    };
    extraConfig = ''
      # Layer rules
      # layerrule = blur,waybar
      # layerrule = ignorezero,waybar

      # Gestures (Hyprland v0.51+ syntax)
      # finger count, direction, action
      gesture = 3, horizontal, workspace
      bind = $mainMod, R, submap, resize
      submap = resize
      binde = , right, resizeactive, 15 0
      binde = , left, resizeactive, -15 0
      binde = , up, resizeactive, 0 -15
      binde = , down, resizeactive, 0 15
      binde = , l, resizeactive, 15 0
      binde = , h, resizeactive, -15 0
      binde = , k, resizeactive, 0 -15
      binde = , j, resizeactive, 0 15
      bind = , escape, submap, reset
      submap = reset

      # Global resize binds (not in submap)
      bind = CTRL SHIFT, left, resizeactive, -15 0
      bind = CTRL SHIFT, right, resizeactive, 15 0
      bind = CTRL SHIFT, up, resizeactive, 0 -15
      bind = CTRL SHIFT, down, resizeactive, 0 15
      bind = CTRL SHIFT, l, resizeactive, 15 0
      bind = CTRL SHIFT, h, resizeactive, -15 0
      bind = CTRL SHIFT, k, resizeactive, 0 -15
      bind = CTRL SHIFT, j, resizeactive, 0 15

      # hyprswipe
	  bind = , swipe:3:r, hyprswipe:right
      bind = , swipe:3:l, hyprswipe:left
      bind = , swipe:3:u, hyprswipe:up
      bind = , swipe:3:d, hyprswipe:down
      # test keyboard binds
            bind = SUPER SHIFT, up, hyprswipe:up
            bind = SUPER SHIFT, down, hyprswipe:down

      # hyprtasking
       # bind = SUPER, tab, hyprtasking:toggle, cursor
       # bind = SUPER, space, hyprtasking:toggle, all
       # bind = , escape, hyprtasking:if_active, hyprtasking:toggle cursor

      # blur
      windowrulev2 = opacity 0.9 0.9,class:^(org\.gnome\.Nautilus|thunar|pavucontrol)$
    '';
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprscrolling
      # inputs.hyprtasking.packages.${pkgs.stdenv.hostPlatform.system}.hyprtasking
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      inputs.hypr-dynamic-cursors.packages.${pkgs.stdenv.hostPlatform.system}.hypr-dynamic-cursors
      inputs.hyprswipe.packages.${pkgs.stdenv.hostPlatform.system}.hyprswipe
    ];
  };
}
