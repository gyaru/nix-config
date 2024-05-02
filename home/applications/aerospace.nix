{...}: {
  home.file.aerospace = {
    target = ".aerospace.toml";
    text = ''
      enable-normalization-flatten-containers = false
      enable-normalization-opposite-orientation-for-nested-containers = false

      [gaps]
      inner.horizontal = 15
      inner.vertical   = 15
      outer.left       = 15
      outer.bottom     = 15
      outer.top        = 15
      outer.right      = 15

      [mode.main.binding]
      alt-enter = 'exec-and-forget open -n kitty'

      alt-j = 'focus left'
      alt-k = 'focus down'
      alt-l = 'focus up'
      alt-semicolon = 'focus right'

      alt-shift-j = 'move left'
      alt-shift-k = 'move down'
      alt-shift-l = 'move up'
      alt-shift-semicolon = 'move right'

      alt-h = 'split horizontal'
      alt-v = 'split vertical'

      alt-f = 'fullscreen'

      alt-s = 'layout v_accordion' # 'layout stacking' in i3
      alt-w = 'layout h_accordion' # 'layout tabbed' in i3
      alt-e = 'layout tiles horizontal vertical' # 'layout toggle split' in i3

      alt-shift-space = 'layout floating tiling' # 'floating toggle' in i3

      # Not supported, because this command is redundant in AeroSpace mental model.
      # See: https://nikitabobko.github.io/AeroSpace/guide#floating-windows
      #alt-space = 'focus toggle_tiling_floating'

      # `focus parent`/`focus child` are not yet supported, and it's not clear whether they
      # should be supported at all https://github.com/nikitabobko/AeroSpace/issues/5
      # alt-a = 'focus parent'

      alt-1 = 'workspace 1'
      alt-2 = 'workspace 2'
      alt-3 = 'workspace 3'
      alt-4 = 'workspace 4'
      alt-5 = 'workspace 5'
      alt-6 = 'workspace 6'
      alt-7 = 'workspace 7'
      alt-8 = 'workspace 8'
      alt-9 = 'workspace 9'
      alt-0 = 'workspace 10'

      alt-shift-1 = 'move-node-to-workspace 1'
      alt-shift-2 = 'move-node-to-workspace 2'
      alt-shift-3 = 'move-node-to-workspace 3'
      alt-shift-4 = 'move-node-to-workspace 4'
      alt-shift-5 = 'move-node-to-workspace 5'
      alt-shift-6 = 'move-node-to-workspace 6'
      alt-shift-7 = 'move-node-to-workspace 7'
      alt-shift-8 = 'move-node-to-workspace 8'
      alt-shift-9 = 'move-node-to-workspace 9'
      alt-shift-0 = 'move-node-to-workspace 10'

      alt-shift-c = 'reload-config'

      alt-r = 'mode resize'

      [mode.resize.binding]
      h = 'resize width -50'
      j = 'resize height +50'
      k = 'resize height -50'
      l = 'resize width +50'
      enter = 'mode main'
      esc = 'mode main'
    '';
  };
}
