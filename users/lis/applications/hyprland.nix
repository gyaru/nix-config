{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];
  home.packages = with pkgs; [jaq xorg.xprop];

  # hyprland config
  wayland.windowManager.hyprland.extraConfig = ''
    # displays
    monitor = DP-1, 3440x1440@160, 1440x450, 1, bitdepth, 8
    monitor = HDMI-A-1, 2560x1440@60, 0x0, 1, transform, 1, bitdepth, 8

    # workspaces
    workspace = name:1, monitor:DP-1
    workspace = name:2, monitor:DP-1
    workspace = name:3, monitor:DP-1
    workspace = name:4, monitor:DP-1
    workspace = name:5, monitor:DP-1
    workspace = name:6, monitor:HDMI-A-1

    # set wallpapers
    # wallpaper ultrawide
    exec-once = swaybg -o DP-1 -i ~/.local/share/wallpapers/bg1.jpg -m fill
    # wallpaper portrait
    exec-once = swaybg -o HDMI-A-1 -i ~/.local/share/wallpapers/bg2.jpg -m fill

    # panel
    exec-once = ags

    # xdph
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

    # inputs
    input {
        kb_layout = us,se
        follow_mouse = 1
        force_no_accel = true
        repeat_delay = 250
    }

    # general
    general {
        gaps_in = 10
        gaps_out = 15
        border_size = 3
        col.active_border = 0xFF931500
        col.inactive_border = 0xFF931500
        layout = dwindle
    }

    # misc
    misc {
        disable_hyprland_logo = true
        vrr = 0
        key_press_enables_dpms = true
        mouse_move_enables_dpms = true
    }

    # animations (why)
    animations {
        enabled = false
    }

    # dwindle layout
    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    # windows rules
    # fix telegram media preview
    windowrulev2 = float, class:org.telegram.desktop, title:Media viewer

    # fix wine winecfg being cropped
    windowrulev2 = nomaxsize, title:^(Wine configuration)$
    windowrulev2 = forceinput, title:^(Wine configuration)$

    # fix wine dialogs being cropped
    windowrulev2 = minsize 899 556, class:^(battle.net.exe)$, title:^(.*Installation.*)$

    # fix vscode
    windowrulev2=fakefullscreen, class:^(code-url-handler)$

    # games
    windowrulev2 = workspace 5, class:^(wowclassic.exe)$ # wow classic
    windowrulev2 = forceinput, class:^(wowclassic.exe)$ # wow classic
    windowrulev2 = workspace 5, class:^(overwatch.exe)$ # overwatch
    windowrulev2 = forceinput, class:^(overwatch.exe)$ # overwatch
    windowrulev2 = forceinput, class:^(leagueclientux.exe)$ # league of legends
    windowrulev2 = workspace 4, class:^(leagueclientux.exe)$ # league of legends
    windowrulev2 = maxsize 1920 1080, class:^(leagueclientux.exe)$ # league of legends - client
    windowrulev2 = minsize 1920 1080, class:^(leagueclientux.exe)$ # league of legends - client
    windowrulev2 = minsize 1534 831, class:^(riotclientux.exe)$ # league of legends - riot client
    windowrulev2 = maxsize 1534 831, class:^(riotclientux.exe)$ # league of legends - riot client
    windowrulev2 = center, class:^(leagueclientux.exe)$ # league of legends - client
    windowrulev2 = forceinput, class:^(league of legends.exe)$ # league of legends - game
    windowrulev2 = fullscreen, class:^(league of legends.exe)$ # league of legends - game
    windowrulev2 = workspace 5, class:^(league of legends.exe)$ # league of legends` - game
    windowrulev2 = float, title:^(RuneLite)$ - runescape

    # application workspaces
    windowrulev2 = workspace 4, class:^(Steam)$
    windowrulev2 = workspace 6, class:^(obs)$
    windowrulev2 = workspace 6, class:^(Spotify)$
    windowrulev2 = workspace 5, title:^(Steam Big Picture)$

    # bindings
    # terminal
    bind = SUPER, Return, exec, wezterm

    # application launcher
    bind = SUPER, Space, exec, anyrun

    # browser
    bind = SUPER, O, exec, firefox

    # colour picker
    bind = SUPER, C, exec, hyprpicker -a

    # kill selected window
    bind = SUPER SHIFT, W, killactive,

    # quit hyprland
    bind = SUPER SHIFT, M, exec, wlogout

    # fullscreen screen shot
    bind = SUPER, F11, exec, grim -o DP-1 # fix notification

    # region screenshot
    bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" # fix notification

    # fullscreen video recording

    # region video recording
    # shift ctrl super s?

    # toggle focus to floating
    bind = SUPER, F, togglefloating,

    # toggle focus to pseudo tiled
    bind = SUPER, P, pseudo,

    # toggle split
    bind = SUPER, S, togglesplit, # dwindle

    # toggle fullscreen

    # move focus with arrow keys
    bind = SUPER, left, movefocus, l
    bind = SUPER, right, movefocus, r
    bind = SUPER, up, movefocus, u
    bind = SUPER, down, movefocus, d

    # preselect with arrow keys
    bind = SUPER SHIFT, left, layoutmsg, preselect l
    bind = SUPER SHIFT, right, layoutmsg, preselect r
    bind = SUPER SHIFT, up, layoutmsg, preselect u
    bind = SUPER SHIFT, down, layoutmsg, preselect d

    # switch workspaces
    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    # send active window to given workspace
    bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
    bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
    bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
    bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
    bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
    bind = SUPER SHIFT, 6, movetoworkspacesilent, 6

    # move and resize windows with mouse
    bindm = SUPER, mouse:272, movewindow
    bindm = SUPER, mouse:273, resizewindow

    # volume control
    bindl =, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindl =, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    # media
    bindl =, XF86AudioNext, exec, playerctl next -i chromium
    bindl =, XF86AudioPrev, exec, playerctl previous -i chromium
    bindl =, XF86AudioPlay, exec, playerctl play-pause -i chromium

    # toggle keyboard layout
    bind=, XF86Calculator, exec, hyprctl switchxkblayout kbdfans-kbd67mkiirgb-v2 next
  '';

  # enable hyprland
  wayland.windowManager.hyprland.enable = true;
}
