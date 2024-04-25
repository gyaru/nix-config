{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];
  home.packages = with pkgs; [jaq xorg.xprop];

  wayland.windowManager.hyprland.settings = {
    general = {
      border_size = 3;
      gaps_in = 10;
      gaps_out = 10;
      "col.active_border" = "0xFF931500";
      "col.inactive_border" = "0xFF931500";
      layout = "dwindle";
    };
    decoration = {
      drop_shadow = false;
      blur = {
        enabled = false;
      };
    };
    animations = {
      enabled = false;
    };
    input = {
      follow_mouse = 1;
      force_no_accel = true;
      repeat_delay = 250;
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      vrr = 0;
    };
    dwindle = {
      pseudotile = false;
      preserve_split = "yes";
      no_gaps_when_only = false;
    };
    bind = [
      "SUPER, Return, exec, wezterm"
      "SUPER, Space, exec, anyrun"
      "SUPER, O, exec, firefox"
      "SUPER, C, exec, hyprpicker -a"
      "SUPER SHIFT, W, killactive,"
      "SUPER SHIFT, M, exec, wlogout"
      "SUPER, F11, exec, grim -o DP-1" # fix notification
      "SUPER, F, togglefloating,"
      "SUPER, P, pseudo,"
      "SUPER, S, togglesplit," # dwindle
      # move focus with arrow keys
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"
      # preselect with arrow keys
      "SUPER SHIFT, left, layoutmsg, preselect l"
      "SUPER SHIFT, right, layoutmsg, preselect r"
      "SUPER SHIFT, up, layoutmsg, preselect u"
      "SUPER SHIFT, down, layoutmsg, preselect d"
      # switch workspaces
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      # send active window to given workspace
      "SUPER SHIFT, 1, movetoworkspacesilent, 1"
      "SUPER SHIFT, 2, movetoworkspacesilent, 2"
      "SUPER SHIFT, 3, movetoworkspacesilent, 3"
      "SUPER SHIFT, 4, movetoworkspacesilent, 4"
      "SUPER SHIFT, 5, movetoworkspacesilent, 5"
      "SUPER SHIFT, 6, movetoworkspacesilent, 6"
    ];
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
    bindl = [
      # volume control
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      # media
      ", XF86AudioNext, exec, playerctl next -i chromium"
      ", XF86AudioPrev, exec, playerctl previous -i chromium"
      ", XF86AudioPlay, exec, playerctl play-pause -i chromium"
    ];
    workspace = [
      "name:1, monitor:DP-1"
      "name:2, monitor:DP-1"
      "name:3, monitor:DP-1"
      "name:4, monitor:DP-1"
      "name:5, monitor:DP-1"
      "name:6, monitor:HDMI-A-1"
    ];
  };

  wayland.windowManager.hyprland.extraConfig = ''
    # displays
    monitor = DP-1, 3440x1440@160, 1440x450, 1, bitdepth, 8
    monitor = HDMI-A-1, 2560x1440@60, 0x0, 1, transform, 1, bitdepth, 8

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
    windowrulev2 = stayfocused, title:^()$,class:^(steam)$
    windowrulev2 = workspace 6, class:^(obs)$
    windowrulev2 = workspace 6, class:^(Spotify)$
    windowrulev2 = workspace 5, title:^(Steam Big Picture)$

    # region screenshot
    bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" # fix notification

    # toggle keyboard layout
    #bind=, XF86Calculator, exec, hyprctl switchxkblayout kbdfans-kbd67mkiirgb-v2 next
  '';

  # enable hyprland
  wayland.windowManager.hyprland.enable = true;
}
