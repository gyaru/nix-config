{default, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require "wezterm"
      local config = {}
      if wezterm.config_builder then
      config = wezterm.config_builder()
      end

      -- font
      config.font =
      wezterm.font_with_fallback { "M PLUS 1 Code", "Maple Mono NF", "Noto Color Emoji" }
      config.font_size = 12

      -- disable things we don't really need
      config.enable_scroll_bar = false
      config.enable_tab_bar = false
      config.check_for_updates = false
      config.window_close_confirmation = "NeverPrompt"

      -- keybindings
      config.disable_default_key_bindings = true
      config.keys = {
      {
          key = 'C',
          mods = 'SHIFT|CTRL',
          action = wezterm.action.CopyTo "Clipboard",
      },
      {
          key = 'V',
          mods = 'SHIFT|CTRL',
          action = wezterm.action.PasteFrom "Clipboard",
      },
      }

      -- cosmetics
      config.default_cursor_style = "BlinkingBar"
      config.color_scheme = "rose-pine-dawn"
      config.window_padding = {
          left = 5,
          right = 5,
          top = 5,
          bottom = 5,
      }

      config.colors = {
        selection_fg = '#f2e9e1',
        selection_bg = '#d7827e',
      }

      return config
    '';
  };
}
